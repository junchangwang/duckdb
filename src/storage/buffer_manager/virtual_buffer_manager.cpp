#include "duckdb/storage/virtual_buffer_manager.hpp"
#include "duckdb/common/allocator.hpp"
#include "duckdb/common/exception.hpp"
#include "duckdb/storage/buffer_manager.hpp"
#include "duckdb/common/file_buffer.hpp"

namespace duckdb {

shared_ptr<BlockHandle> VirtualBufferManager::RegisterSmallMemory(idx_t block_size) {
	throw NotImplementedException("This type of BufferManager can not create 'small-memory' blocks");
}

// unique_ptr<VirtualBufferManager> VirtualBufferManager::CreateBufferManager(DatabaseInstance &db, string
// temp_directory,
//                                                              idx_t maximum_memory) {
//	return make_unique<BufferManager>(db, temp_directory, maximum_memory);
// }

Allocator &VirtualBufferManager::GetBufferAllocator() {
	throw NotImplementedException("This type of BufferManager does not have an Allocator");
}

void VirtualBufferManager::ReserveMemory(idx_t size) {
	throw NotImplementedException("This type of BufferManager can not reserve memory");
}
void VirtualBufferManager::FreeReservedMemory(idx_t size) {
	throw NotImplementedException("This type of BufferManager can not free reserved memory");
}

void VirtualBufferManager::SetLimit(idx_t limit) {
	throw NotImplementedException("This type of BufferManager can not set a limit");
}

const string &VirtualBufferManager::GetTemporaryDirectory() {
	// FIXME: does this cause a problem because it's expecting a reference?
	return "";
}

void VirtualBufferManager::SetTemporaryDirectory(string new_dir) {
	throw NotImplementedException("This type of BufferManager can not set a temporary directory");
}

DatabaseInstance &VirtualBufferManager::GetDatabase() {
	throw NotImplementedException("This type of BufferManager is not linked to a DatabaseInstance");
}

bool VirtualBufferManager::HasTemporaryDirectory() const {
	return false;
}

unique_ptr<FileBuffer> VirtualBufferManager::ConstructManagedBuffer(idx_t size, unique_ptr<FileBuffer> &&source,
                                                                    FileBufferType type) {
	throw NotImplementedException("This type of BufferManager can not construct managed buffers");
}

// Protected methods

void AddToEvictionQueue(shared_ptr<BlockHandle> &handle) {
	throw NotImplementedException("This type of BufferManager does not support 'AddToEvictionQueue");
}

void WriteTemporaryBuffer(block_id_t block_id, FileBuffer &buffer) {
	throw NotImplementedException("This type of BufferManager does not support 'WriteTemporaryBuffer");
}

unique_ptr<FileBuffer> ReadTemporaryBuffer(block_id_t id, unique_ptr<FileBuffer> buffer) {
	throw NotImplementedException("This type of BufferManager does not support 'ReadTemporaryBuffer");
}

void DeleteTemporaryFile(block_id_t id) {
	throw NotImplementedException("This type of BufferManager does not support 'DeleteTemporaryFile");
}

} // namespace duckdb
