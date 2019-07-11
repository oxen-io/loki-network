import Foundation
import NetworkExtension

/// The general idea here is to intercept packets, pass them to the Lokinet core so that it can modify them as described by the LLARP Traffic Routing Protocol, and then pass them to the appropriate snode(s).
final class LKPacketTunnelProvider : NEPacketTunnelProvider {
    
    override func startTunnel(options: [String:NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {
        Darwin.sleep(10) // Give the user opportunity to attach the debugger
        let directoryPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.niels-andriesse.loki-network")!.path
        let configurationFileName = "lokinet-configuration.ini"
        let bootstrapFileURL = URL(string: "https://i2p.rocks/i2procks.signed")!
        let bootstrapFileName = "bootstrap.signed"
        let daemonConfiguration = LKDaemon.Configuration(isDebuggingEnabled: false, directoryPath: directoryPath, configurationFileName: configurationFileName, bootstrapFileURL: bootstrapFileURL, bootstrapFileName: bootstrapFileName)
        LKUpdateConnectionProgress(0.2)
        LKDaemon.configure(with: daemonConfiguration).done { _, context in
            let isSuccess = LKDaemon.start(with: context)
            completionHandler(isSuccess ? nil : LKError.startingDaemonFailed)
        }.catch { error in
            completionHandler(error)
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        LKDaemon.stop()
        completionHandler()
    }
}
