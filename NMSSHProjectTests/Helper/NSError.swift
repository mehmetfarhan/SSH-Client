//
//  NSError.swift
//  NMSSHProjectTests
//
//  Created by mnocfarhan on 4/10/19.
//  Copyright © 2019 MohammadFarhan. All rights reserved.
//

import Foundation

extension NSError {
    static func error(_ message: String) -> NSError {
        return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
