//
//  MockURL.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/10/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

struct MockURL: URLTestable {

    let timeout: TimeInterval = 30
    let data: Data? = nil
    let iteration: Int = 1
    let error: Error? = nil
    let response: MockHTTPURLResponse? = nil
    let expectation: XCTestExpectation? = nil

    var urlRequest: URLRequestTestable {
        return MockRequest(url: self,
                           timeout: timeout,
                           data: data,
                           iteration: iteration,
                           error: error,
                           response: response,
                           expectation: expectation)
    }
}
