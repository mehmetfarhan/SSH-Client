//
//  Result.swift
//  NMSSHProjectTests
//
//  Created by mnocfarhan on 4/10/19.
//  Copyright © 2019 MohammadFarhan. All rights reserved.
//

import Foundation
@testable import NMSSHProject

extension Result: Equatable {
    public static func ==<T>(lhs: Result<T>, rhs: Result<T>) -> Bool {
        return String(stringInterpolationSegment: lhs) == String(stringInterpolationSegment: rhs)
    }
}
