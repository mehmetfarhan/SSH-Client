//
//  SSHPresenter.swift
//  NMSSHProject
//
//  Created by Mohammad Farhan on 4/7/19.
//  Copyright © 2019 MohammadFarhan. All rights reserved.
//

import Foundation

protocol SSHPresenterInput {
    func performCommand(after text: String)
    func shouldChangeTextIn(_ string: String) -> Bool
    func viewDidLoad()
}

protocol SSHPresentation: ViewDisplayable {
    func append(text: String)
    func drop()
    func clearText()
    func replace(text: String)
    func setTextFieldEnabled(isEnabled: Bool)
    func configure()
}

final class SSHPresenter {
    
    // MARK: - Properties
    
    private weak var view: SSHPresentation?
    private let gateway: SSHGateway
    var lastCommand = ""
    private var textViewLength = 0
    private var range = NSRange()
    private var connectionModel: ConnectionModel
    
    //
    // MARK: - Init / Deinit
    
    init(view: SSHPresentation,
         gateway: SSHGateway,
         connectionModel: ConnectionModel) {
        self.view = view
        self.gateway = gateway
        self.connectionModel = connectionModel
        self.view?.displayView(title: connectionModel.address)
    }
}

// MARK: - SSH Presenter Input

extension SSHPresenter: SSHPresenterInput {
    
    func viewDidLoad() {
        view?.configure()
        connect()
    }
    
    func shouldChangeTextIn(_ string: String) -> Bool {
        
        if string == "" , !lastCommand.isEmpty {
            view?.drop()
        } else {
            view?.append(text: string)
        }
        
        lastCommand += string
        performCommand(after: string)
        return true
    }
    
    func performCommand(after text: String) {
        let returnText = "\n"
        guard text == returnText else { return }
        view?.clearText()
        write()
    }
    
}

// MARK: - Gateway

extension SSHPresenter {
    
    func write() {
        gateway.write(command: lastCommand) { [weak self] in
            self?.lastCommand = ""
        }
    }
    
    func connect() {
        gateway.connect(toHost: connectionModel.host, withUsername: connectionModel.username, byPassword: connectionModel.password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view?.setTextFieldEnabled(isEnabled: true)
                self.view?.append(text: "ssh \(self.connectionModel.username)@\(self.connectionModel.host)\n")
            case let .failure(error):
                self.view?.setTextFieldEnabled(isEnabled: false)
                self.view?.append(text: error.localizedDescription)
            }
        }
    }
}

// MARK: - SSH Session Delegate

extension SSHPresenter: SSHSessionDelegate {
    func channel(didReadData message: String) {
        let clearText = "clear"
        if message.prefix(clearText.count) == clearText {
            view?.replace(text: message)
        }
        view?.append(text: message)
    }
    
    func channel(didReadError error: String) {
        view?.append(text: "[ERROR] \(error)")
    }
    
    func session(didDisconnectWithError error: Error) {
        view?.append(text: "\nDisconnected with error: \(error.localizedDescription)")
        view?.setTextFieldEnabled(isEnabled: false)
    }
    
    func channelShellDidClose() {
        view?.append(text: "\nShell closed\n")
        view?.setTextFieldEnabled(isEnabled: false)
    }
}
