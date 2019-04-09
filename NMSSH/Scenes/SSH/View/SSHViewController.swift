//
//  SSHViewController.swift
//  NMSSH
//
//  Created by Mohammad Farhan on 4/3/19.
//  Copyright © 2019 MohammadFarhan. All rights reserved.
//


import UIKit
import IQKeyboardManagerSwift
import Signals

class SSHViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Properties
    
    var presenter: SSHPresenter!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.smartDashesType = .no
        let gateway = SSHGatewayImplementation()
        presenter = SSHPresenter(view: self, gateway: gateway)
        gateway.sessionDelegate = presenter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: - Interactors
    
    @IBAction func connect(_ sender: Any) {
        presenter.connect(toHost: presenter.host, withUsername: presenter.username, byPassword: presenter.password)
    }
}

// MARK: - TextView Delegate

extension SSHViewController: UITextViewDelegate {
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        textView.resignFirstResponder()
    }
    
    func append(toTextView text: String?) {
        textView.text = "\(textView.text ?? "")\(text ?? "")"
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let selectedRange = presenter.textViewSelectedRange(textView.text, selectedRange: textView.selectedRange) else { return }
        textView.selectedRange = selectedRange
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let length = textView.text?.utf8.count
        return presenter.shouldChangeTextIn(text, textViewLength: length, range: range)
    }
}

// MARK: - SSH Presentation

extension SSHViewController: SSHPresentation {
    
    func append(text: String) {
        DispatchQueue.main.async(execute: {
            self.append(toTextView: text)
        })
    }
    
    func replace(text: String) {
        DispatchQueue.main.async(execute: {
            self.textView.text = text
        })
    }

    func setTextViewEditable(isEditable: Bool) {
        DispatchQueue.main.async(execute: {
            self.textView.isEditable = isEditable
        })
    }
}
