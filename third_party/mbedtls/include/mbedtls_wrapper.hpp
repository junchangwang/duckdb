//===----------------------------------------------------------------------===//
//                         DuckDB
//
// mbedtls_wrapper.hpp
//
//
//===----------------------------------------------------------------------===//

#pragma once

#include "duckdb/common/aes_state.hpp"
#include "duckdb/common/optional_ptr.hpp"
#include "duckdb/common/typedefs.hpp"

#include <string>

namespace duckdb_mbedtls {

class MbedTlsWrapper {
public:
	static void ComputeSha256Hash(const char *in, size_t in_len, char *out);
	static std::string ComputeSha256Hash(const std::string &file_content);
	static bool IsValidSha256Signature(const std::string &pubkey, const std::string &signature,
	                                   const std::string &sha256_hash);
	static void Hmac256(const char *key, size_t key_len, const char *message, size_t message_len, char *out);
	static void ToBase16(char *in, char *out, size_t len);

	static constexpr size_t SHA256_HASH_LENGTH_BYTES = 32;
	static constexpr size_t SHA256_HASH_LENGTH_TEXT = 64;

	class SHA256State {
	public:
		SHA256State();
		~SHA256State();
		void AddString(const std::string &str);
		std::string Finalize();
		void FinishHex(char *out);

	private:
		void *sha_context;
	};

	class AESGCMStateMBEDTLS : public duckdb::AESGCMState {
	public:
		DUCKDB_API explicit AESGCMStateMBEDTLS();
		DUCKDB_API ~AESGCMStateMBEDTLS() override;

	public:
		DUCKDB_API bool IsOpenSSL() override;
		DUCKDB_API void InitializeEncryption(duckdb::const_data_ptr_t iv, duckdb::idx_t iv_len, const std::string *key) override;
		DUCKDB_API void InitializeDecryption(duckdb::const_data_ptr_t iv, duckdb::idx_t iv_len, const std::string *key) override;
		DUCKDB_API size_t Process(duckdb::const_data_ptr_t in, duckdb::idx_t in_len, duckdb::data_ptr_t out,
		               duckdb::idx_t out_len) override;
		DUCKDB_API size_t Finalize(duckdb::data_ptr_t out, duckdb::idx_t out_len, duckdb::data_ptr_t tag, duckdb::idx_t tag_len) override;
		DUCKDB_API void GenerateRandomData(duckdb::data_ptr_t data, duckdb::idx_t len) override;
		DUCKDB_API const std::string GetLib();

	public:
		static constexpr size_t BLOCK_SIZE = 16;
		const std::string lib = "mbedtls";
		static constexpr bool SSL = false;

	private:
		void *gcm_context;
	};
};

class AESGCMStateMBEDTLSFactory : public duckdb::AESStateFactory {
public:
	duckdb::shared_ptr<duckdb::AESGCMState> CreateAesState() const override {
		return duckdb::shared_ptr<MbedTlsWrapper::AESGCMStateMBEDTLS>(new MbedTlsWrapper::AESGCMStateMBEDTLS());
	}

	~AESGCMStateMBEDTLSFactory() override {} //
};

} // namespace duckdb_mbedtls
