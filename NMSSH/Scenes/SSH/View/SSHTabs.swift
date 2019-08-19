//
//  SSHTabs.swift
//  NMSSHProject
//
//  Created by mnocfarhan on 4/15/19.
//  Copyright © 2019 MohammadFarhan. All rights reserved.
//

import UIKit

final class ViewController: TabViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarButtonItems()
    }
    
    // MARK: - Configurations

    private func configureBarButtonItems() {
        let addItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addTab))
        navigationItem.rightBarButtonItem = addItem
    }
    
    // MARK: - Actions

    @objc private func addTab() {
        let model = ConnectionModel(host: "209.73.216.67", port: 22, username: "admin", password: "J3llyfish1")
        let controller = ViewControllersAssembly.sshController(connectionModel: model)
        self.activateTab(controller)
    }
    
    @objc private func toggleTheme() {
        // The theme can be changed at any time by setting the `theme` property.
        if type(of: self.theme) == TabViewThemeLight.self {
            self.theme = TabViewThemeDark()
        } else {
            self.theme = TabViewThemeLight()
        }
    }
    
}
