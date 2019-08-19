//
//  SSHViewController.swift
//  NMSSH
//
//  Created by Mohammad Farhan on 4/3/19.
//  Copyright © 2019 MohammadFarhan. All rights reserved.
//


import UIKit

class SSHViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!

    // MARK: - Properties
    
    var presenter: SSHPresenter!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        IQKeyboardManager.shared.enable = true
    }
}

// MARK: - TextView Helper

extension SSHViewController {
    
    func changeContentInsetOfTextView() {
        var inset: UIEdgeInsets = .zero
        inset.top = textView.bounds.size.height - textView.contentSize.height
        textView.contentInset = inset
        textView.scrollToBotom()
    }

    func append(toTextView text: String?) {
        textView.text = "\(textView.text ?? "")\(text ?? "")"
    }
}

// MARK: - SSH Presentation

extension SSHViewController: SSHPresentation {
    
    func configure() {
        textField.isHidden = true
        textField.delegate = self
        textField.tintColor = .clear
    }
    
    func clearText() {
        textField.text = nil
    }
    
    func drop() {
        DispatchQueue.main.async(execute: {
            self.textView.text.removeLast()
        })
    }
    
    func append(text: String) {
        DispatchQueue.main.async(execute: {
            self.textField.becomeFirstResponder()
            self.append(toTextView: text)
            self.changeContentInsetOfTextView()
        })
    }
    
    func replace(text: String) {
        DispatchQueue.main.async(execute: {
            self.textView.text = text
        })
    }

    func setTextFieldEnabled(isEnabled: Bool) {
        DispatchQueue.main.async(execute: {
            self.textField.isEnabled = isEnabled
            self.textField.resignFirstResponder()
        })
    }
}


extension SSHViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return presenter.shouldChangeTextIn(string)
    }
    
    
}

extension UITextView {
    
    func scrollToBotom() {
        let range = NSMakeRange(text.utf8.count - 1, 1);
        scrollRangeToVisible(range);
    }
    
}
