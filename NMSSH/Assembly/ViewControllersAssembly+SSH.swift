//
//  ViewControllersAssembly+SSH.swift
//  NMSSHProject
//
//  Created by mnocfarhan on 4/15/19.
//  Copyright © 2019 MohammadFarhan. All rights reserved.
//

import UIKit

extension ViewControllersAssembly {
    
    static func sshController(connectionModel: ConnectionModel) -> UIViewController {
        let view: SSHViewController = ssh.makeViewController()
        let gateway = SSHGatewayImplementation()
        let presenter = SSHPresenter(view: view, gateway: gateway, connectionModel: connectionModel)
        gateway.sessionDelegate = presenter
        view.presenter = presenter
        return view
    }
    
}
