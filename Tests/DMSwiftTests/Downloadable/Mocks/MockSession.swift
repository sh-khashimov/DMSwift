//
//  MockSession.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 11/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class MockSession: URLSessionTestable {

    var mockTask: URLSessionTaskTestable?
    var delegate: URLSessionDelegate?
    let expectation: XCTestExpectation?

    private var type: URLSessionTaskType?

    init(delegate: URLSessionDelegate?, expectation: XCTestExpectation? = nil) {
        self.delegate = delegate
        self.expectation = expectation
    }

    func dataTask(with request: URLRequestTestable) -> URLSessionTaskTestable {
        type = .dataTask
        mockTask = MockSessionDataTask(mockRequest: request as? MockRequest)
        return mockTask!
    }

    func downloadTask(with request: URLRequestTestable) -> URLSessionTaskTestable {
        mockTask = MockSessionDownloadTask(mockRequest: request as? MockRequest)
        return mockTask!
    }

    func finishTasksAndInvalidate() {
        mockTask = nil
    }


}
