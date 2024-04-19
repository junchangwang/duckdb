#include "crypto.hpp"
#include "mbedtls_wrapper.hpp"
#include <iostream>
#include "duckdb/common/common.hpp"
#include <stdio.h>

#define CPPHTTPLIB_OPENSSL_SUPPORT
#include "httplib.hpp"

namespace duckdb {

void sha256(const char *in, size_t in_len, hash_bytes &out) {
	duckdb_mbedtls::MbedTlsWrapper::ComputeSha256Hash(in, in_len, (char *)out);
}

void hmac256(const std::string &message, const char *secret, size_t secret_len, hash_bytes &out) {
	duckdb_mbedtls::MbedTlsWrapper::Hmac256(secret, secret_len, message.data(), message.size(), (char *)out);
}

void hmac256(std::string message, hash_bytes secret, hash_bytes &out) {
	hmac256(message, (char *)secret, sizeof(hash_bytes), out);
}

void hex256(hash_bytes &in, hash_str &out) {
	const char *hex = "0123456789abcdef";
	unsigned char *pin = in;
	unsigned char *pout = out;
	for (; pin < in + sizeof(in); pout += 2, pin++) {
		pout[0] = hex[(*pin >> 4) & 0xF];
		pout[1] = hex[*pin & 0xF];
	}
}

const EVP_CIPHER *GetCipher(const string &key) {
	// For now, only ciphers for GCM Mode
	switch (key.size()) {
	case 16:
		return EVP_aes_128_gcm();
	case 24:
		return EVP_aes_192_gcm();
	case 32:
		return EVP_aes_256_gcm();
	default:
		throw InternalException("Invalid AES key length");
	}
}

AESGCMStateSSL::AESGCMStateSSL() : gcm_context(EVP_CIPHER_CTX_new()) {
	auto context = reinterpret_cast<evp_cipher_ctx_st *>(gcm_context);
	if (!(context)) {
		throw InternalException("AES GCM failed with initializing context");
	}
}

AESGCMStateSSL::~AESGCMStateSSL() {
	// Clean up
	EVP_CIPHER_CTX_free(reinterpret_cast<evp_cipher_ctx_st *>(gcm_context));
}

bool AESGCMStateSSL::IsOpenSSL() {
	return SSL;
}

void AESGCMStateSSL::GenerateRandomData(data_ptr_t data, idx_t len) {
	// generate random bytes for nonce
	RAND_bytes(data, len);
}

void AESGCMStateSSL::InitializeEncryption(const_data_ptr_t iv, idx_t iv_len, const string *key) {
	auto context = reinterpret_cast<evp_cipher_ctx_st *>(gcm_context);
	// Encryption mode
	mode = false;
	if (1 !=
	    EVP_EncryptInit_ex(context, GetCipher(*key), NULL, reinterpret_cast<const unsigned char *>(key->data()), iv)) {
		throw InternalException("AES CTR failed with EncryptInit");
	}
}

void AESGCMStateSSL::InitializeDecryption(const_data_ptr_t iv, idx_t iv_len, const string *key) {
	auto context = reinterpret_cast<evp_cipher_ctx_st *>(gcm_context);
	// Decryption mode
	mode = true;
	if (1 !=
	    EVP_DecryptInit_ex(context, GetCipher(*key), NULL, reinterpret_cast<const unsigned char *>(key->data()), iv)) {
		throw std::runtime_error("EVP_EncryptInit_ex failed");
	}
}

size_t AESGCMStateSSL::Process(const_data_ptr_t in, idx_t in_len, data_ptr_t out, idx_t out_len) {
	auto context = reinterpret_cast<evp_cipher_ctx_st *>(gcm_context);
	if (!mode) {
		if (1 != EVP_EncryptUpdate(context, reinterpret_cast<unsigned char *>(out), reinterpret_cast<int *>(&out_len),
		                           reinterpret_cast<const unsigned char *>(in), (int)in_len)) {
			throw InternalException("AES GCM failed with encrypt update gcm");
		}
	} else {
		if (1 != EVP_DecryptUpdate(context, reinterpret_cast<unsigned char *>(out), reinterpret_cast<int *>(&out_len),
		                           reinterpret_cast<const unsigned char *>(in), (int)in_len)) {

			throw InternalException("AES GCM failed with decrypt update");
		}
	}
	if (out_len != in_len) {
		throw InternalException("AES GCM failed, in- and output lengths differ");
	}
	return out_len;
}

size_t AESGCMStateSSL::Finalize(data_ptr_t out, idx_t out_len, data_ptr_t tag, idx_t tag_len) {
	auto context = reinterpret_cast<evp_cipher_ctx_st *>(gcm_context);
	auto text_len = out_len;
	if (!mode) {
		// Encrypt
		if (1 != EVP_EncryptFinal_ex(context, reinterpret_cast<unsigned char *>(out) + out_len,
		                             reinterpret_cast<int *>(&out_len))) {
			throw InternalException("AES GCM failed, with finalizing encryption");
		}
		text_len += out_len;
		// For GCM, the calculated tag is written at the end of a chunk
		if (1 != EVP_CIPHER_CTX_ctrl(context, EVP_CTRL_GCM_GET_TAG, tag_len, tag)) {
			throw InternalException("AES GCM failed with calculating the tag");
		}
		return text_len;

	} else {
		// Set expected tag value
		if (!EVP_CIPHER_CTX_ctrl(context, EVP_CTRL_GCM_SET_TAG, tag_len, tag)) {
			throw InternalException("AES GCM failed with finalizing tag value");
		}
		// EVP_DecryptFinal() will return an error code if padding is enabled
		// and the final block is not correctly formatted.
		int ret = EVP_DecryptFinal_ex(context, reinterpret_cast<unsigned char *>(out) + out_len,
		                              reinterpret_cast<int *>(&out_len));
		text_len += out_len;

		if (ret > 0) {
			// success
			return text_len;
		}
		throw InvalidInputException("Computed AES tag differs from read AES tag, are you using the right key?");
	}
}

} // namespace duckdb
