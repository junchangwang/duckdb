#include "duckdb/function/aggregate/distributive_functions.hpp"
#include "duckdb/common/exception.hpp"
#include "duckdb/common/vector_operations/vector_operations.hpp"
#include "duckdb/common/operator/comparison_operators.hpp"
#include "duckdb/common/value_operations/value_operations.hpp"
#include "duckdb/common/vector_operations/aggregate_executor.hpp"
#include "duckdb/common/operator/aggregate_operators.hpp"
#include "duckdb/common/types/null_value.hpp"
#include "duckdb/planner/expression.hpp"

namespace duckdb {

template <class T>
struct MinMaxState {
	T value;
	bool isset;
};

template <class OP>
static AggregateFunction GetUnaryAggregate(LogicalType type) {
	switch (type.InternalType()) {
	case PhysicalType::BOOL:
		return AggregateFunction::UnaryAggregate<MinMaxState<int8_t>, int8_t, int8_t, OP>(type, type);
	case PhysicalType::INT8:
		return AggregateFunction::UnaryAggregate<MinMaxState<int8_t>, int8_t, int8_t, OP>(type, type);
	case PhysicalType::INT16:
		return AggregateFunction::UnaryAggregate<MinMaxState<int16_t>, int16_t, int16_t, OP>(type, type);
	case PhysicalType::INT32:
		return AggregateFunction::UnaryAggregate<MinMaxState<int32_t>, int32_t, int32_t, OP>(type, type);
	case PhysicalType::INT64:
		return AggregateFunction::UnaryAggregate<MinMaxState<int64_t>, int64_t, int64_t, OP>(type, type);
	case PhysicalType::UINT8:
		return AggregateFunction::UnaryAggregate<MinMaxState<uint8_t>, uint8_t, uint8_t, OP>(type, type);
	case PhysicalType::UINT16:
		return AggregateFunction::UnaryAggregate<MinMaxState<uint16_t>, uint16_t, uint16_t, OP>(type, type);
	case PhysicalType::UINT32:
		return AggregateFunction::UnaryAggregate<MinMaxState<uint32_t>, uint32_t, uint32_t, OP>(type, type);
	case PhysicalType::UINT64:
		return AggregateFunction::UnaryAggregate<MinMaxState<uint64_t>, uint64_t, uint64_t, OP>(type, type);
	case PhysicalType::INT128:
		return AggregateFunction::UnaryAggregate<MinMaxState<hugeint_t>, hugeint_t, hugeint_t, OP>(type, type);
	case PhysicalType::FLOAT:
		return AggregateFunction::UnaryAggregate<MinMaxState<float>, float, float, OP>(type, type);
	case PhysicalType::DOUBLE:
		return AggregateFunction::UnaryAggregate<MinMaxState<double>, double, double, OP>(type, type);
	case PhysicalType::INTERVAL:
		return AggregateFunction::UnaryAggregate<MinMaxState<interval_t>, interval_t, interval_t, OP>(type, type);
	default:
		throw InternalException("Unimplemented type for min/max aggregate");
	}
}

struct MinMaxBase {
	template <class STATE>
	static void Initialize(STATE *state) {
		state->isset = false;
	}

	template <class INPUT_TYPE, class STATE, class OP>
	static void ConstantOperation(STATE *state, AggregateInputData &, INPUT_TYPE *input, ValidityMask &mask,
	                              idx_t count) {
		D_ASSERT(mask.RowIsValid(0));
		if (!state->isset) {
			OP::template Assign<INPUT_TYPE, STATE>(state, input[0]);
			state->isset = true;
		} else {
			OP::template Execute<INPUT_TYPE, STATE>(state, input[0]);
		}
	}

	template <class INPUT_TYPE, class STATE, class OP>
	static void Operation(STATE *state, AggregateInputData &, INPUT_TYPE *input, ValidityMask &mask, idx_t idx) {
		if (!state->isset) {
			OP::template Assign<INPUT_TYPE, STATE>(state, input[idx]);
			state->isset = true;
		} else {
			OP::template Execute<INPUT_TYPE, STATE>(state, input[idx]);
		}
	}

	static bool IgnoreNull() {
		return true;
	}
};

struct NumericMinMaxBase : public MinMaxBase {
	template <class INPUT_TYPE, class STATE>
	static void Assign(STATE *state, INPUT_TYPE input) {
		state->value = input;
	}

	template <class T, class STATE>
	static void Finalize(Vector &result, AggregateInputData &, STATE *state, T *target, ValidityMask &mask, idx_t idx) {
		mask.Set(idx, state->isset);
		target[idx] = state->value;
	}
};

struct MinOperation : public NumericMinMaxBase {
	template <class INPUT_TYPE, class STATE>
	static void Execute(STATE *state, INPUT_TYPE input) {
		if (LessThan::Operation<INPUT_TYPE>(input, state->value)) {
			state->value = input;
		}
	}

	template <class STATE, class OP>
	static void Combine(const STATE &source, STATE *target, AggregateInputData &) {
		if (!source.isset) {
			// source is NULL, nothing to do
			return;
		}
		if (!target->isset) {
			// target is NULL, use source value directly
			*target = source;
		} else if (GreaterThan::Operation(target->value, source.value)) {
			target->value = source.value;
		}
	}
};

struct MaxOperation : public NumericMinMaxBase {
	template <class INPUT_TYPE, class STATE>
	static void Execute(STATE *state, INPUT_TYPE input) {
		if (GreaterThan::Operation<INPUT_TYPE>(input, state->value)) {
			state->value = input;
		}
	}

	template <class STATE, class OP>
	static void Combine(const STATE &source, STATE *target, AggregateInputData &) {
		if (!source.isset) {
			// source is NULL, nothing to do
			return;
		}
		if (!target->isset) {
			// target is NULL, use source value directly
			*target = source;
		} else if (LessThan::Operation(target->value, source.value)) {
			target->value = source.value;
		}
	}
};

struct StringMinMaxBase : public MinMaxBase {
	template <class STATE>
	static void Destroy(STATE *state) {
		if (state->isset && !state->value.IsInlined()) {
			delete[] state->value.GetDataUnsafe();
		}
	}

	template <class INPUT_TYPE, class STATE>
	static void Assign(STATE *state, INPUT_TYPE input) {
		Destroy(state);
		if (input.IsInlined()) {
			state->value = input;
		} else {
			// non-inlined string, need to allocate space for it
			auto len = input.GetSize();
			auto ptr = new char[len];
			memcpy(ptr, input.GetDataUnsafe(), len);

			state->value = string_t(ptr, len);
		}
	}

	template <class T, class STATE>
	static void Finalize(Vector &result, AggregateInputData &, STATE *state, T *target, ValidityMask &mask, idx_t idx) {
		if (!state->isset) {
			mask.SetInvalid(idx);
		} else {
			target[idx] = StringVector::AddStringOrBlob(result, state->value);
		}
	}

	template <class STATE, class OP>
	static void Combine(const STATE &source, STATE *target, AggregateInputData &) {
		if (!source.isset) {
			// source is NULL, nothing to do
			return;
		}
		if (!target->isset) {
			// target is NULL, use source value directly
			Assign(target, source.value);
			target->isset = true;
		} else {
			OP::template Execute<string_t, STATE>(target, source.value);
		}
	}
};

struct MinOperationString : public StringMinMaxBase {
	template <class INPUT_TYPE, class STATE>
	static void Execute(STATE *state, INPUT_TYPE input) {
		if (LessThan::Operation<INPUT_TYPE>(input, state->value)) {
			Assign(state, input);
		}
	}
};

struct MaxOperationString : public StringMinMaxBase {
	template <class INPUT_TYPE, class STATE>
	static void Execute(STATE *state, INPUT_TYPE input) {
		if (GreaterThan::Operation<INPUT_TYPE>(input, state->value)) {
			Assign(state, input);
		}
	}
};

template <typename T, class OP>
static bool TemplatedOptimumType(Vector &left, idx_t lidx, idx_t lcount, Vector &right, idx_t ridx, idx_t rcount) {
	UnifiedVectorFormat lvdata, rvdata;
	left.ToUnifiedFormat(lcount, lvdata);
	right.ToUnifiedFormat(rcount, rvdata);

	lidx = lvdata.sel->get_index(lidx);
	ridx = rvdata.sel->get_index(ridx);

	auto ldata = (const T *)lvdata.data;
	auto rdata = (const T *)rvdata.data;

	auto &lval = ldata[lidx];
	auto &rval = rdata[ridx];

	auto lnull = !lvdata.validity.RowIsValid(lidx);
	auto rnull = !rvdata.validity.RowIsValid(ridx);

	return OP::Operation(lval, rval, lnull, rnull);
}

template <class OP>
static bool TemplatedOptimumList(Vector &left, idx_t lidx, idx_t lcount, Vector &right, idx_t ridx, idx_t rcount);

template <class OP>
static bool TemplatedOptimumStruct(Vector &left, idx_t lidx, idx_t lcount, Vector &right, idx_t ridx, idx_t rcount);

template <class OP>
static bool TemplatedOptimumValue(Vector &left, idx_t lidx, idx_t lcount, Vector &right, idx_t ridx, idx_t rcount) {
	D_ASSERT(left.GetType() == right.GetType());
	switch (left.GetType().InternalType()) {
	case PhysicalType::BOOL:
	case PhysicalType::INT8:
		return TemplatedOptimumType<int8_t, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::INT16:
		return TemplatedOptimumType<int16_t, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::INT32:
		return TemplatedOptimumType<int32_t, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::INT64:
		return TemplatedOptimumType<int64_t, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::UINT8:
		return TemplatedOptimumType<uint8_t, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::UINT16:
		return TemplatedOptimumType<uint16_t, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::UINT32:
		return TemplatedOptimumType<uint32_t, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::UINT64:
		return TemplatedOptimumType<uint64_t, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::INT128:
		return TemplatedOptimumType<hugeint_t, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::FLOAT:
		return TemplatedOptimumType<float, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::DOUBLE:
		return TemplatedOptimumType<double, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::INTERVAL:
		return TemplatedOptimumType<interval_t, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::VARCHAR:
		return TemplatedOptimumType<string_t, OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::LIST:
		return TemplatedOptimumList<OP>(left, lidx, lcount, right, ridx, rcount);
	case PhysicalType::STRUCT:
		return TemplatedOptimumStruct<OP>(left, lidx, lcount, right, ridx, rcount);
	default:
		throw InternalException("Invalid type for distinct comparison");
	}
}

template <class OP>
static bool TemplatedOptimumStruct(Vector &left, idx_t lidx_p, idx_t lcount, Vector &right, idx_t ridx_p,
                                   idx_t rcount) {
	// STRUCT dictionaries apply to all the children
	// so map the indexes first
	UnifiedVectorFormat lvdata, rvdata;
	left.ToUnifiedFormat(lcount, lvdata);
	right.ToUnifiedFormat(rcount, rvdata);

	idx_t lidx = lvdata.sel->get_index(lidx_p);
	idx_t ridx = rvdata.sel->get_index(ridx_p);

	// DISTINCT semantics are in effect for nested types
	auto lnull = !lvdata.validity.RowIsValid(lidx);
	auto rnull = !rvdata.validity.RowIsValid(ridx);
	if (lnull || rnull) {
		return OP::Operation(0, 0, lnull, rnull);
	}

	auto &lchildren = StructVector::GetEntries(left);
	auto &rchildren = StructVector::GetEntries(right);

	D_ASSERT(lchildren.size() == rchildren.size());
	for (idx_t col_no = 0; col_no < lchildren.size(); ++col_no) {
		auto &lchild = *lchildren[col_no];
		auto &rchild = *rchildren[col_no];

		// Strict comparisons use the OP for definite
		if (TemplatedOptimumValue<OP>(lchild, lidx_p, lcount, rchild, ridx_p, rcount)) {
			return true;
		}

		if (col_no == lchildren.size() - 1) {
			break;
		}

		// Strict comparisons use IS NOT DISTINCT for possible
		if (!TemplatedOptimumValue<NotDistinctFrom>(lchild, lidx_p, lcount, rchild, ridx_p, rcount)) {
			return false;
		}
	}

	return false;
}

template <class OP>
static bool TemplatedOptimumList(Vector &left, idx_t lidx, idx_t lcount, Vector &right, idx_t ridx, idx_t rcount) {
	UnifiedVectorFormat lvdata, rvdata;
	left.ToUnifiedFormat(lcount, lvdata);
	right.ToUnifiedFormat(rcount, rvdata);

	// Update the indexes and vector sizes for recursion.
	lidx = lvdata.sel->get_index(lidx);
	ridx = rvdata.sel->get_index(ridx);

	lcount = ListVector::GetListSize(left);
	rcount = ListVector::GetListSize(right);

	// DISTINCT semantics are in effect for nested types
	auto lnull = !lvdata.validity.RowIsValid(lidx);
	auto rnull = !rvdata.validity.RowIsValid(ridx);
	if (lnull || rnull) {
		return OP::Operation(0, 0, lnull, rnull);
	}

	auto &lchild = ListVector::GetEntry(left);
	auto &rchild = ListVector::GetEntry(right);

	auto ldata = (const list_entry_t *)lvdata.data;
	auto rdata = (const list_entry_t *)rvdata.data;

	auto &lval = ldata[lidx];
	auto &rval = rdata[ridx];

	for (idx_t pos = 0;; ++pos) {
		// Tie-breaking uses the OP
		if (pos == lval.length || pos == rval.length) {
			return OP::Operation(lval.length, rval.length, false, false);
		}

		// Strict comparisons use the OP for definite
		lidx = lval.offset + pos;
		ridx = rval.offset + pos;
		if (TemplatedOptimumValue<OP>(lchild, lidx, lcount, rchild, ridx, rcount)) {
			return true;
		}

		// Strict comparisons use IS NOT DISTINCT for possible
		if (!TemplatedOptimumValue<NotDistinctFrom>(lchild, lidx, lcount, rchild, ridx, rcount)) {
			return false;
		}
	}

	return false;
}

struct VectorMinMaxState {
	Vector *value;
};

struct VectorMinMaxBase {
	static bool IgnoreNull() {
		return true;
	}

	template <class STATE>
	static void Initialize(STATE *state) {
		state->value = nullptr;
	}

	template <class STATE>
	static void Destroy(STATE *state) {
		if (state->value) {
			delete state->value;
		}
		state->value = nullptr;
	}

	template <class STATE>
	static void Assign(STATE *state, Vector &input, const idx_t idx) {
		if (!state->value) {
			state->value = new Vector(input.GetType());
			state->value->SetVectorType(VectorType::CONSTANT_VECTOR);
		}
		sel_t selv = idx;
		SelectionVector sel(&selv);
		VectorOperations::Copy(input, *state->value, sel, 1, 0, 0);
	}

	template <class STATE>
	static void Execute(STATE *state, Vector &input, const idx_t idx, const idx_t count) {
		Assign(state, input, idx);
	}

	template <class STATE, class OP>
	static void Update(Vector inputs[], AggregateInputData &, idx_t input_count, Vector &state_vector, idx_t count) {
		auto &input = inputs[0];
		UnifiedVectorFormat idata;
		input.ToUnifiedFormat(count, idata);

		UnifiedVectorFormat sdata;
		state_vector.ToUnifiedFormat(count, sdata);

		auto states = (STATE **)sdata.data;
		for (idx_t i = 0; i < count; i++) {
			const auto idx = idata.sel->get_index(i);
			if (!idata.validity.RowIsValid(idx)) {
				continue;
			}
			const auto sidx = sdata.sel->get_index(i);
			auto state = states[sidx];
			if (!state->value) {
				Assign(state, input, i);
			} else {
				OP::template Execute(state, input, i, count);
			}
		}
	}

	template <class STATE, class OP>
	static void Combine(const STATE &source, STATE *target, AggregateInputData &) {
		if (!source.value) {
			return;
		} else if (!target->value) {
			Assign(target, *source.value, 0);
		} else {
			OP::template Execute(target, *source.value, 0, 1);
		}
	}

	template <class T, class STATE>
	static void Finalize(Vector &result, AggregateInputData &, STATE *state, T *target, ValidityMask &mask, idx_t idx) {
		if (!state->value) {
			// we need to use SetNull here
			// since for STRUCT columns only setting the validity mask of the struct is incorrect
			// as for a struct column, we need to also set ALL child columns to NULL
			switch (result.GetVectorType()) {
			case VectorType::FLAT_VECTOR:
				FlatVector::SetNull(result, idx, true);
				break;
			case VectorType::CONSTANT_VECTOR:
				ConstantVector::SetNull(result, true);
				break;
			default:
				throw InternalException("Invalid result vector type for nested min/max");
			}
		} else {
			VectorOperations::Copy(*state->value, result, 1, 0, idx);
		}
	}

	static unique_ptr<FunctionData> Bind(ClientContext &context, AggregateFunction &function,
	                                     vector<unique_ptr<Expression>> &arguments) {
		function.arguments[0] = arguments[0]->return_type;
		function.return_type = arguments[0]->return_type;
		return nullptr;
	}
};

struct MinOperationVector : public VectorMinMaxBase {
	template <class STATE>
	static void Execute(STATE *state, Vector &input, const idx_t idx, const idx_t count) {
		if (TemplatedOptimumValue<DistinctLessThan>(input, idx, count, *state->value, 0, 1)) {
			Assign(state, input, idx);
		}
	}
};

struct MaxOperationVector : public VectorMinMaxBase {
	template <class STATE>
	static void Execute(STATE *state, Vector &input, const idx_t idx, const idx_t count) {
		if (TemplatedOptimumValue<DistinctGreaterThan>(input, idx, count, *state->value, 0, 1)) {
			Assign(state, input, idx);
		}
	}
};

template <class OP>
unique_ptr<FunctionData> BindDecimalMinMax(ClientContext &context, AggregateFunction &function,
                                           vector<unique_ptr<Expression>> &arguments) {
	auto decimal_type = arguments[0]->return_type;
	auto name = function.name;
	switch (decimal_type.InternalType()) {
	case PhysicalType::INT16:
		function = GetUnaryAggregate<OP>(LogicalType::SMALLINT);
		break;
	case PhysicalType::INT32:
		function = GetUnaryAggregate<OP>(LogicalType::INTEGER);
		break;
	case PhysicalType::INT64:
		function = GetUnaryAggregate<OP>(LogicalType::BIGINT);
		break;
	default:
		function = GetUnaryAggregate<OP>(LogicalType::HUGEINT);
		break;
	}
	function.name = Move(name);
	function.arguments[0] = decimal_type;
	function.return_type = decimal_type;
	return nullptr;
}

template <typename OP, typename STATE>
static AggregateFunction GetMinMaxFunction(const LogicalType &type) {
	return AggregateFunction({type}, type, AggregateFunction::StateSize<STATE>,
	                         AggregateFunction::StateInitialize<STATE, OP>, OP::template Update<STATE, OP>,
	                         AggregateFunction::StateCombine<STATE, OP>,
	                         AggregateFunction::StateFinalize<STATE, void, OP>, nullptr, OP::Bind,
	                         AggregateFunction::StateDestroy<STATE, OP>);
}

template <class OP, class OP_STRING, class OP_VECTOR>
static AggregateFunction GetMinMaxOperator(const LogicalType &type) {
	if (type.InternalType() == PhysicalType::VARCHAR) {
		return AggregateFunction::UnaryAggregateDestructor<MinMaxState<string_t>, string_t, string_t, OP_STRING>(
		    type.id(), type.id());
	} else if (type.InternalType() == PhysicalType::LIST || type.InternalType() == PhysicalType::STRUCT) {
		return GetMinMaxFunction<OP_VECTOR, VectorMinMaxState>(type);
	} else {
		return GetUnaryAggregate<OP>(type);
	}
}

template <class OP, class OP_STRING, class OP_VECTOR>
unique_ptr<FunctionData> BindMinMax(ClientContext &context, AggregateFunction &function,
                                    vector<unique_ptr<Expression>> &arguments) {
	auto input_type = arguments[0]->return_type;
	auto name = Move(function.name);
	function = GetMinMaxOperator<OP, OP_STRING, OP_VECTOR>(input_type);
	function.name = Move(name);
	if (function.bind) {
		return function.bind(context, function, arguments);
	} else {
		return nullptr;
	}
}

template <class OP, class OP_STRING, class OP_VECTOR>
static void AddMinMaxOperator(AggregateFunctionSet &set) {
	set.AddFunction(AggregateFunction({LogicalTypeId::DECIMAL}, LogicalTypeId::DECIMAL, nullptr, nullptr, nullptr,
	                                  nullptr, nullptr, nullptr, BindDecimalMinMax<OP>));
	set.AddFunction(AggregateFunction({LogicalType::ANY}, LogicalType::ANY, nullptr, nullptr, nullptr, nullptr, nullptr,
	                                  nullptr, BindMinMax<OP, OP_STRING, OP_VECTOR>));
}

void MinFun::RegisterFunction(BuiltinFunctions &set) {
	AggregateFunctionSet min("min");
	AddMinMaxOperator<MinOperation, MinOperationString, MinOperationVector>(min);
	set.AddFunction(min);
}

void MaxFun::RegisterFunction(BuiltinFunctions &set) {
	AggregateFunctionSet max("max");
	AddMinMaxOperator<MaxOperation, MaxOperationString, MaxOperationVector>(max);
	set.AddFunction(max);
}

} // namespace duckdb
