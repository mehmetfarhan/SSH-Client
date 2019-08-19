//
//  ViewControllersAssembly.swift
//  NMSSHProject
//
//  Created by mnocfarhan on 4/15/19.
//  Copyright © 2019 MohammadFarhan. All rights reserved.
//

import UIKit

final class ViewControllersAssembly {
    
    // MARK: - Static properties
    
    static private(set) var ssh: UIStoryboard = { UIStoryboard(name: "SSH") }()
    
}

extension UIStoryboard {
    
    // MARK: - Init / Deinit
    
    convenience init(name: String) {
        self.init(name: name, bundle: .main)
    }
    
    // MARK: - Actions
    
    // swiftlint:disable force_cast
    func makeViewController<T: StoryboardInitiable>() -> T {
        return instantiateViewController(withIdentifier: T.storyboardIdentifier) as! T
    }
    
    func makeViewController(with storyboardIdentifier: String) -> UIViewController {
        return instantiateViewController(withIdentifier: storyboardIdentifier)
    }
    // swiftlint:enable force_cast
    
}
