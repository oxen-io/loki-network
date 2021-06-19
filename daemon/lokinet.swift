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
        let providerProtocol = NETunnelProviderProtocol()
        providerProtocol.providerBundleIdentifier = self.lokinetComponent
        providerProtocol.isEnabled = true
        self.vpnManager.protocolConfiguration = providerProtocol

        self.vpnManager.saveToPreferences(completionHandler: {(error) -> Void in
                if(error != nil) {
                    print("Error saving to preferences")
                } else {
                    print("saved...")
                    self.vpnManager.loadFromPreferences(completionHandler: { (error) in
                        if (error != nil) {
                            print("Error loading from preferences")
                        } else {
                            do {
                                print("Trying to start")
                                self.initializeConnectionObserver()
                                try self.vpnManager.connection.startVPNTunnel()
                            } catch let error as NSError {
                                print(error)
                            } catch {
                                print("There was a fatal error")
                            }
                        }
                    })
                }
                                          })
        print("wait...")
    }

    func initializeConnectionObserver () {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: self.vpnManager.connection, queue: OperationQueue.main) { (notification) -> Void in

            if self.vpnManager.connection.status == .invalid {
                print("VPN configuration is invalid")
            } else if self.vpnManager.connection.status == .disconnected {
                print("VPN is disconnected.")
            } else if self.vpnManager.connection.status == .connecting {
                print("VPN is connecting...")
            } else if self.vpnManager.connection.status == .reasserting {
                print("VPN is reasserting...")
            } else if self.vpnManager.connection.status == .disconnecting {
                print("VPN is disconnecting...")
            }
        }
    }
}


let lokinet = LokinetMain()
lokinet.runMain()
