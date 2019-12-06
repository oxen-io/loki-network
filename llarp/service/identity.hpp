#ifndef LLARP_SERVICE_IDENTITY_HPP
#define LLARP_SERVICE_IDENTITY_HPP

#include <config/key_manager.hpp>
#include <constants/proto.hpp>
#include <crypto/types.hpp>
#include <memory>
#include <service/info.hpp>
#include <service/intro_set.hpp>
#include <service/vanity.hpp>
#include <util/buffer.hpp>

#include <tuple>

namespace llarp
{
  namespace service
  {
    // private keys
    struct Identity
    {
      SecretKey enckey;
      SecretKey signkey;
      PQKeyPair pq;
      uint64_t version = LLARP_PROTO_VERSION;
      VanityNonce vanity;

      // public service info
      ServiceInfo pub;

      // regenerate secret keys
      void
      RegenerateKeys(const std::string& fname, std::shared_ptr<KeyManager> keyManager);

      bool
      BEncode(llarp_buffer_t* buf) const;

      bool
      EnsureKeys(const std::string& fpath, std::shared_ptr<KeyManager> keyManager);

      bool
      KeyExchange(path_dh_func dh, SharedSecret& sharedkey,
                  const ServiceInfo& other, const KeyExchangeNonce& N) const;

      bool
      DecodeKey(const llarp_buffer_t& key, llarp_buffer_t* buf);

      bool
      SignIntroSet(IntroSet& i, llarp_time_t now) const;

      bool
      Sign(Signature& sig, const llarp_buffer_t& buf) const;
    };

    inline bool
    operator==(const Identity& lhs, const Identity& rhs)
    {
      return std::tie(lhs.enckey, lhs.signkey, lhs.pq, lhs.version, lhs.vanity)
          == std::tie(rhs.enckey, rhs.signkey, rhs.pq, rhs.version, rhs.vanity);
    }
  }  // namespace service
}  // namespace llarp

#endif
