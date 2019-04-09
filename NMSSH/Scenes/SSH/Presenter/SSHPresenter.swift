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
    func replaceSubrange()
    func shouldChangeTextIn(_ text: String, textViewLength: Int?, range: NSRange) -> Bool
    func textViewSelectedRange(_ text: String, selectedRange: NSRange) -> NSRange?
}

protocol SSHPresentation: class {
    func append(text: String)
    func replace(text: String)
    func setTextViewEditable(isEditable: Bool)
}

final class SSHPresenter {
    
    // MARK: - Properties
    
    private weak var view: SSHPresentation!
    var host: String = "13.78.148.225"
    var username: String = "hala95"
    var password: String = "hala95!"
    private let gateway: SSHGateway
    var lastCommand = ""
    private var textViewLength = 0
    private var range = NSRange()
//
    // MARK: - Init / Deinit
    
    init(view: SSHPresentation,
         gateway: SSHGateway) {
        self.view = view
        self.gateway = gateway
    }
}

// MARK: - SSH Presenter Input

extension SSHPresenter: SSHPresenterInput {
    
    func textViewSelectedRange(_ text: String, selectedRange: NSRange) -> NSRange? {
        if selectedRange.location < text.utf16.count - lastCommand.count {
            return NSRange(location: text.utf16.count, length: 0)
        }
        return nil
    }
    
    func shouldChangeTextIn(_ text: String, textViewLength: Int?, range: NSRange) -> Bool {
        if let length = textViewLength { self.textViewLength = length }
        self.range = range
        
        if text.isEmpty {
            if lastCommand.count > 0 {
                replaceSubrange()
                return true
            } else {
                return false
            }
        }
        
        lastCommand += text
        performCommand(after: text)
        return true
    }
    
    func replaceSubrange() {
        let range = NSRange(location: lastCommand.utf8.count - 1, length: 1)
        guard let subRange = Range<String.Index>(range, in: lastCommand) else { return }
        lastCommand.replaceSubrange(subRange, with: "")
        
//        let offset = range.location - (textViewLength - lastCommand.count)
//        if let index = lastCommand.index(lastCommand.startIndex,
//                                         offsetBy: offset,
//                                         limitedBy: lastCommand.endIndex) {
//            lastCommand.remove(at: index)
//        }
    }
    
    func performCommand(after text: String) {
        let returnText = "\n"
        guard text == returnText else { return }
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
    
    func connect(toHost: String, withUsername: String, byPassword: String) {
        gateway.connect(toHost: toHost, withUsername: withUsername, byPassword: byPassword) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view.setTextViewEditable(isEditable: true)
                self.view.append(text: "ssh \(self.username)@\(self.host)\n")
            case let .failure(error):
                self.view.setTextViewEditable(isEditable: false)
                self.view.append(text: error.localizedDescription)
            }
        }
    }
}


// MARK: - SSH Session Delegate

extension SSHPresenter: SSHSessionDelegate {
    func channel(didReadData message: String) {
        let clearText = "clear"
        if message.prefix(clearText.count) == clearText {
            view.replace(text: message)
        }
        view.append(text: message)
    }
    
    func channel(didReadError error: String) {
        view.append(text: "[ERROR] \(error)")
    }
    
    func session(didDisconnectWithError error: Error) {
        view.append(text: "\nDisconnected with error: \(error.localizedDescription)")
        view.setTextViewEditable(isEditable: false)
    }
    
    func channelShellDidClose() {
        view.append(text: "\nShell closed\n")
        view.setTextViewEditable(isEditable: false)
    }
}
