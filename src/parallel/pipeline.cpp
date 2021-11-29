#include "duckdb/parallel/pipeline.hpp"

#include "duckdb/common/printer.hpp"
#include "duckdb/execution/executor.hpp"
#include "duckdb/main/client_context.hpp"
#include "duckdb/parallel/thread_context.hpp"
#include "duckdb/parallel/task_scheduler.hpp"
#include "duckdb/main/database.hpp"

#include "duckdb/execution/operator/aggregate/physical_simple_aggregate.hpp"
#include "duckdb/execution/operator/aggregate/physical_window.hpp"
#include "duckdb/execution/operator/scan/physical_table_scan.hpp"
#include "duckdb/execution/operator/order/physical_order.hpp"
#include "duckdb/execution/operator/aggregate/physical_hash_aggregate.hpp"
#include "duckdb/execution/operator/join/physical_hash_join.hpp"
#include "duckdb/parallel/pipeline_executor.hpp"
#include "duckdb/parallel/pipeline_event.hpp"

#include "duckdb/common/algorithm.hpp"
#include "duckdb/common/tree_renderer.hpp"

namespace duckdb {

class PipelineTask : public ExecutorTask {
public:
	explicit PipelineTask(Pipeline &pipeline_p, shared_ptr<Event> event_p)
	    : ExecutorTask(pipeline_p.executor), pipeline(pipeline_p), event(move(event_p)) {
	}

	Pipeline &pipeline;
	shared_ptr<Event> event;

public:
	void ExecuteTask() override {
		PipelineExecutor executor(pipeline.GetClientContext(), pipeline);
		executor.Execute();
		event->FinishTask();
	}
};

Pipeline::Pipeline(Executor &executor_p) : executor(executor_p), ready(false), source(nullptr), sink(nullptr) {
}

ClientContext &Pipeline::GetClientContext() {
	return executor.context;
}

// LCOV_EXCL_START
bool Pipeline::GetProgressInternal(ClientContext &context, PhysicalOperator *op, int &current_percentage) {
	current_percentage = -1;
	switch (op->type) {
	case PhysicalOperatorType::TABLE_SCAN: {
		auto &get = (PhysicalTableScan &)*op;
		if (get.function.table_scan_progress) {
			current_percentage = get.function.table_scan_progress(context, get.bind_data.get());
			return true;
		}
		//! If the table_scan_progress is not implemented it means we don't support this function yet in the progress
		//! bar
		return false;
	}
	default:
		return false;
	}
}
// LCOV_EXCL_STOP

bool Pipeline::GetProgress(int &current_percentage) {
	auto &client = executor.context;
	return GetProgressInternal(client, source, current_percentage);
}

void Pipeline::ScheduleSequentialTask(shared_ptr<Event> &event) {
	vector<unique_ptr<Task>> tasks;
	tasks.push_back(make_unique<PipelineTask>(*this, event));
	event->SetTasks(move(tasks));
}

bool Pipeline::ScheduleParallel(shared_ptr<Event> &event) {
	if (!sink->ParallelSink()) {
		return false;
	}
	if (!source->ParallelSource()) {
		return false;
	}
	for (auto &op : operators) {
		if (!op->ParallelOperator()) {
			return false;
		}
	}
	idx_t max_threads = source_state->MaxThreads();
	return LaunchScanTasks(event, max_threads);
}

void Pipeline::Schedule(shared_ptr<Event> &event) {
	D_ASSERT(ready);
	D_ASSERT(sink);
	if (!ScheduleParallel(event)) {
		// could not parallelize this pipeline: push a sequential task instead
		ScheduleSequentialTask(event);
	}
}

bool Pipeline::LaunchScanTasks(shared_ptr<Event> &event, idx_t max_threads) {
	// split the scan up into parts and schedule the parts
	auto &scheduler = TaskScheduler::GetScheduler(executor.context);
	idx_t active_threads = scheduler.NumberOfThreads();
	if (max_threads > active_threads) {
		max_threads = active_threads;
	}
	if (max_threads <= 1) {
		// too small to parallelize
		return false;
	}

	// launch a task for every thread
	vector<unique_ptr<Task>> tasks;
	for (idx_t i = 0; i < max_threads; i++) {
		tasks.push_back(make_unique<PipelineTask>(*this, event));
	}
	event->SetTasks(move(tasks));
	return true;
}

void Pipeline::Reset() {
	if (sink && !sink->sink_state) {
		sink->sink_state = sink->GetGlobalSinkState(GetClientContext());
	}
	ResetSource();
}

void Pipeline::ResetSource() {
	source_state = source->GetGlobalSourceState(GetClientContext());
}

void Pipeline::Ready() {
	if (ready) {
		return;
	}
	ready = true;
	std::reverse(operators.begin(), operators.end());
	Reset();
}

void Pipeline::Finalize(Event &event) {
	D_ASSERT(ready);
	try {
		auto sink_state = sink->Finalize(*this, event, executor.context, *sink->sink_state);
		auto primary_key_flag = sink->sink_state->has_primary_key.load(); // atomically load
		executor.context.config.has_primary_key.store(primary_key_flag);  // atomically store it
		sink->sink_state->state = sink_state;
	} catch (Exception &ex) { // LCOV_EXCL_START
		executor.PushError(ex.type, ex.what());
	} catch (std::exception &ex) {
		executor.PushError(ExceptionType::UNKNOWN_TYPE, ex.what());
	} catch (...) {
		executor.PushError(ExceptionType::UNKNOWN_TYPE, "Unknown exception in Finalize!");
	} // LCOV_EXCL_STOP
}

void Pipeline::AddDependency(shared_ptr<Pipeline> &pipeline) {
	D_ASSERT(pipeline);
	dependencies.push_back(weak_ptr<Pipeline>(pipeline));
	pipeline->parents.push_back(weak_ptr<Pipeline>(shared_from_this()));
}

string Pipeline::ToString() const {
	TreeRenderer renderer;
	return renderer.ToString(*this);
}

void Pipeline::Print() const {
	Printer::Print(ToString());
}

vector<PhysicalOperator *> Pipeline::GetOperators() const {
	vector<PhysicalOperator *> result;
	D_ASSERT(source);
	result.push_back(source);
	result.insert(result.end(), operators.begin(), operators.end());
	if (sink) {
		result.push_back(sink);
	}
	return result;
}

} // namespace duckdb
