
// AppDelegateExtension.swift
// lifed from yggdrasil network ios port
//

import Foundation
import NetworkExtension
import LokinetExtension

class LokinetMain: NSObject {
    var vpnManager: NETunnelProviderManager = NETunnelProviderManager()

    let lokinetComponent = "org.lokinet.NetworkExtension"
    var lokinetAdminTimer: DispatchSourceTimer?


    func runMain() {
        print("Starting up lokinet")
        NETunnelProviderManager.loadAllFromPreferences { (savedManagers: [NETunnelProviderManager]?, error: Error?) in
            if let error = error {
                print(error)
            }

            if let savedManagers = savedManagers {
                for manager in savedManagers {
                    if (manager.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier == self.lokinetComponent {
                        print("Found saved VPN Manager")
                        self.vpnManager = manager
                    }
                }
            }

            self.vpnManager.loadFromPreferences(completionHandler: { (error: Error?) in
                if let error = error {
                    print(error)
                }

                self.vpnManager.localizedDescription = "Lokinet"
                self.vpnManager.isEnabled = true
            })
        }

        do
        {
            try self.vpnManager.connection.startVPNTunnel()
        }
        catch {
            switch self.vpnManager.connection.status {
            case NEVPNStatus.invalid:
                print("lokinet connection invalid")
            default:
                print("lokinet did not start")
            }
        }
        
    }
}


let lokinet = LokinetMain()
lokinet.runMain()

