//
//  MockRequest.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 11/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class MockRequest: URLRequestTestable {

    var timeout: TimeInterval
    let url: URL?
    let data: Data?
    let iteration: Int
    let error: Error?
    let response: MockHTTPURLResponse?
    let expectation: XCTestExpectation?
    var session: MockSession?

    init(url: URLTestable, timeout: TimeInterval = 30, data: Data? = nil, iteration: Int = 1, error: Error? = nil, response: MockHTTPURLResponse? = nil, expectation: XCTestExpectation? = nil) {
        self.url = url.urlRequest.url
        self.timeout = timeout
        self.data = data
        self.error = error
        self.response = response
        self.expectation = expectation
        self.iteration = iteration
    }

    init(url: URL, timeout: TimeInterval = 30, data: Data? = nil, iteration: Int = 1, error: Error? = nil, response: MockHTTPURLResponse? = nil, expectation: XCTestExpectation? = nil) {
        self.url = url
        self.timeout = timeout
        self.data = data
        self.error = error
        self.response = response
        self.expectation = expectation
        self.iteration = iteration
    }

    func session(withTimeout timeout: TimeInterval, delegate: URLSessionDelegate?) -> URLSessionTestable {
        session = MockSession(delegate: delegate, expectation: expectation)
        return session!
    }
}
