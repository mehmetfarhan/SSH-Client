//
//  ConnectionModel.swift
//  NMSSHProject
//
//  Created by mnocfarhan on 4/15/19.
//  Copyright © 2019 MohammadFarhan. All rights reserved.
//

import Foundation

struct ConnectionModel {
    var host: String
    var port: Int
    var username: String
    var password: String
    
    var address: String {
        return "\(host):\(port)"
    }
}
