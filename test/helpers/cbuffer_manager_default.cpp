#include "capi_tester.hpp"
#include "duckdb/storage/cbuffer_manager.hpp"
#include "cbuffer_manager_helpers.hpp"

using namespace duckdb;
using namespace std;

MyBuffer *CreateBuffer(void *allocation, idx_t size, MyBufferManager *buffer_manager) {
	MyBuffer *buffer = (MyBuffer *)malloc(sizeof(MyBuffer));
	if (!buffer) {
		free(allocation);
		throw IOException("Could not allocate %d bytes", sizeof(MyBuffer));
	}
	buffer->size = size;
	buffer->pinned = 0;
	buffer->allocation = allocation;
	buffer->buffer_manager = buffer_manager;
	buffer_manager->allocated_memory += size;
	return buffer;
}

duckdb_buffer Allocate(void *data, idx_t size) {
	auto my_data = (MyBufferManager *)data;
	void *allocation = malloc(size);
	if (!allocation) {
		throw IOException("Could not allocate %d bytes", size);
	}
	return CreateBuffer(allocation, size, my_data);
}

void Destroy(duckdb_buffer buffer) {
	auto my_buffer = (MyBuffer *)buffer;
	auto buffer_manager = my_buffer->buffer_manager;

	// assert that the buffer was not pinned, otherwise it should not be allowed to be destroyed
	D_ASSERT(my_buffer->pinned == 0);

	free(my_buffer->allocation);
	buffer_manager->allocated_memory -= my_buffer->size;
	free(my_buffer);
}

duckdb_buffer ReAllocate(duckdb_buffer buffer, idx_t old_size, idx_t new_size) {
	auto my_buffer = (MyBuffer *)buffer;
	auto buffer_manager = my_buffer->buffer_manager;

	Destroy(buffer);
	return Allocate(buffer_manager, new_size);
}

void *GetAllocation(duckdb_buffer buffer) {
	auto my_buffer = (MyBuffer *)buffer;

	// assert that the buffer was pinned, you should not be allowed to retrieve an allocation from an unpinned buffer
	D_ASSERT(my_buffer->pinned > 0);
	return my_buffer->allocation;
}

void Pin(duckdb_buffer buffer) {
	auto my_buffer = (MyBuffer *)buffer;
	auto buffer_manager = my_buffer->buffer_manager;

	if (my_buffer->pinned != 0) {
		buffer_manager->pinned_buffers++;
	}
	my_buffer->pinned++;
}

void Unpin(duckdb_buffer buffer) {
	auto my_buffer = (MyBuffer *)buffer;
	auto buffer_manager = my_buffer->buffer_manager;

	// assert that the buffer was pinnned
	D_ASSERT(my_buffer->pinned > 0);

	my_buffer->pinned--;
	if (my_buffer->pinned == 0) {
		buffer_manager->pinned_buffers--;
	}
}

idx_t UsedMemory(void *data) {
	auto my_data = (MyBufferManager *)data;

	return my_data->allocated_memory;
}

idx_t MaxMemory(void *data) {
	auto my_data = (MyBufferManager *)data;

	return my_data->max_memory;
}

namespace duckdb {

duckdb::CBufferManagerConfig DefaultCBufferManagerConfig(MyBufferManager *manager) {
	duckdb::CBufferManagerConfig cbuffer_manager_config;

	cbuffer_manager_config.data = manager;
	cbuffer_manager_config.allocate_func = Allocate;
	cbuffer_manager_config.get_allocation_func = GetAllocation;
	cbuffer_manager_config.reallocate_func = ReAllocate;
	cbuffer_manager_config.destroy_func = Destroy;
	cbuffer_manager_config.pin_func = Pin;
	cbuffer_manager_config.unpin_func = Unpin;
	cbuffer_manager_config.max_memory_func = MaxMemory;
	cbuffer_manager_config.used_memory_func = UsedMemory;
	return cbuffer_manager_config;
}

} // namespace duckdb
