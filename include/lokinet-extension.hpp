#pragma once
#include <Foundation/Foundation.h>
#include <NetworkExtension/NetworkExtension.h>

#include <memory>

namespace llarp::apple
{
  class ContextWrapper;
}

@interface LLARPPacketTunnel : NEPacketTunnelProvider
{
 @private
  std::shared_ptr<llarp::apple::ContextWrapper> m_Context;
}
- (void)startTunnelWithOptions:(NSDictionary<NSString*, NSObject*>*)options
             completionHandler:(void (^)(NSError* error))completionHandler;

- (void)stopTunnelWithReason:(NEProviderStopReason)reason
           completionHandler:(void (^)(void))completionHandler;

@end
