//
//  SSHGateway.swift
//  NMSSHProject
//
//  Created by Mohammad Farhan on 4/7/19.
//  Copyright © 2019 MohammadFarhan. All rights reserved.
//

import NMSSH
import UIKit

protocol SSHGateway {
    func write(command: String, handler: @escaping ()->())
    func connect(toHost: String, withUsername: String, byPassword: String, handler: @escaping (Result<Void>) -> ())
}

protocol SSHSessionDelegate {
    func channel(didReadData message: String)
    func channel(didReadError error: String)
    func channelShellDidClose()
    func session(didDisconnectWithError error: Error)
}

class SSHGatewayImplementation: NSObject {
    private var session: NMSSHSession?
    private var sshQueue = DispatchQueue(label: "NMSSH.queue")
    var sessionDelegate: SSHSessionDelegate?
}

private extension SSHGatewayImplementation {
    func configureSession() {
        session?.channel.delegate = self
        session?.channel.requestPty = true
        try? session?.channel.startShell()
    }
}

extension SSHGatewayImplementation: SSHGateway {
    func write(command: String, handler: @escaping () -> ()) {
        sshQueue.async(execute: { [weak self] in
            self?.session?.channel.write(command, error: nil, timeout: 60)
            handler()
        })
    }
    
    func connect(toHost: String, withUsername: String, byPassword: String, handler: @escaping (Result<Void>) -> ()) {
        sshQueue.async(execute: { [weak self] in
            guard let self = self else { return }
            let session = NMSSHSession.connect(toHost: toHost, withUsername: withUsername)
            self.session = session
            if session.isConnected {
                session.authenticate(byPassword: byPassword)
                if session.isAuthorized {
                    self.configureSession()
                    handler(.success(()))
                } else {
                    handler(.failure(SSHError.notAuthorized))
                }
            } else {
                handler(.failure(SSHError.notConnected(toHost)))
            }
        })
    }
    
}

// MARK: - NMSSHSessionDelegate, NMSSHChannelDelegate

extension SSHGatewayImplementation: NMSSHSessionDelegate, NMSSHChannelDelegate {
    
    func channel(_ channel: NMSSHChannel, didReadData message: String) {
        sessionDelegate?.channel(didReadData: message)
    }
    
    func channel(_ channel: NMSSHChannel, didReadError error: String) {
        sessionDelegate?.channel(didReadError: error)
    }
    
    func channelShellDidClose(_ channel: NMSSHChannel) {
        sessionDelegate?.channelShellDidClose()
    }
    
    func session(_ session: NMSSHSession, didDisconnectWithError error: Error) {
        sessionDelegate?.session(didDisconnectWithError: error)
    }
    
}



