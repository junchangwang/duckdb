#include "duckdb/storage/buffer/buffer_handle.hpp"
#include "duckdb/storage/buffer_manager.hpp"

namespace duckdb {

BufferHandle::BufferHandle() : handle(nullptr), node(nullptr) {
}

BufferHandle::BufferHandle(shared_ptr<BlockHandle> handle, FileBuffer *node) : handle(std::move(handle)), node(node) {
}

BufferHandle::BufferHandle(BufferHandle &&other) noexcept {
	std::swap(node, other.node);
	std::swap(handle, other.handle);
}

BufferHandle &BufferHandle::operator=(BufferHandle &&other) noexcept {
	std::swap(node, other.node);
	std::swap(handle, other.handle);
	return *this;
}

BufferHandle::~BufferHandle() {
	Destroy();
}

bool BufferHandle::IsValid() const {
	return node != nullptr;
}

data_ptr_t BufferHandle::Ptr() const {
	D_ASSERT(IsValid());
	return node->Buffer();
}

data_ptr_t BufferHandle::Ptr() {
	D_ASSERT(IsValid());
	return node->Buffer();
}

void BufferHandle::Destroy() {
	if (!handle || !IsValid()) {
		return;
	}
	handle->block_manager.buffer_manager.Unpin(handle);
	handle.reset();
	node = nullptr;
}

FileBuffer &BufferHandle::GetFileBuffer() {
	D_ASSERT(node);
	return *node;
}

} // namespace duckdb
