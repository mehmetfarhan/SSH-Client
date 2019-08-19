//
//  NMSSHProjectTests.swift
//  NMSSHProjectTests
//
//  Created by mnocfarhan on 4/10/19.
//  Copyright © 2019 MohammadFarhan. All rights reserved.
//

import XCTest
import NMSSH
@testable import NMSSHProject

class SSHPresenterTests: XCTestCase {
    
    // MARK: - Properties
    
    var presenter: SSHPresenter!
    let viewMock = SSHViewMock()
    let gateway = SSHGatewayMock()
    
    // MARK: - Set up
    
    override func setUp() {
        presenter = SSHPresenter(
            view: viewMock,
            gateway: gateway
        )
    }
    
    // MARK: - Tests
    
    func testConnectionSuccess() {
        
        // Given
        let host = "192.10.2.22"
        let username = "farhan"
        let password = "j3llyfish1"
        let isTextFieldEnabled = true
        let appendedText = "ssh \(username)@\(host)\n"

        gateway.connectionHandler = .success (())
        
        // When
        presenter.connect(toHost: host, withUsername: username, byPassword: password)
        viewMock.append(text: "ssh \(username)@\(host)\n")

        // Then
        
        XCTAssertEqual(isTextFieldEnabled, viewMock.isEnabled)
        XCTAssertEqual(appendedText, viewMock.appendedText)

    }
    
    func testConnectionFailure() {
        // Given
        let host = "192.10.2.22"
        let username = "farhan"
        let password = "j3llyfish1"
        let isTextFieldEnabled = false
        let appendedText = "ssh \(username)@\(host)\n"
        
        gateway.connectionHandler = .failure (NSError.error("Error"))
        
        // When
        presenter.connect(toHost: host, withUsername: username, byPassword: password)
        viewMock.append(text: "ssh \(username)@\(host)\n")
        
        // Then
        
        XCTAssertEqual(isTextFieldEnabled, viewMock.isEnabled)
        XCTAssertEqual(appendedText, viewMock.appendedText)

    }
    
    
}

class SSHViewMock {
    
    // MARK: - Properties

    var isEnabled: Bool = false
    var appendedText = ""
}

// MARK: - SSHPresentation

extension SSHViewMock: SSHPresentation {
    func append(text: String) {
        self.appendedText = text
    }
    
    func drop() {
    }
    
    func clearText() {
    }
    
    func replace(text: String) {
    }
    
    func setTextFieldEnabled(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    func configure() {
    }
    
}

// MARK: - SSHGateway

class SSHGatewayMock: SSHGateway {
    
    var command: String!
    var toHost: String!
    var username: String!
    var password: String!
    var connectionHandler: Result<Void>!

    func write(command: String, handler: @escaping () -> ()) {
        self.command = command
    }
    
    func connect(toHost: String, withUsername: String, byPassword: String, handler: @escaping (Result<Void>) -> ()) {
        self.toHost = toHost
        self.username = withUsername
        self.password = byPassword
        handler(connectionHandler)
    }
}
