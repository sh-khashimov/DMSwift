//
//  MockSessionTask.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 11/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class MockSessionTask: URLSessionTask {

    var mockRequest: MockRequest?
    var _response: URLResponse?

    override var response: URLResponse? {
        return _response
    }

    var onCompleteWithError: ((_ error: Error?, _ url: URL?) -> Void)?

    init(mockRequest: MockRequest?) {
        self.mockRequest = mockRequest
    }

    override func resume() {
        guard mockRequest?.error != nil else {
            onCompleteWithError?(mockRequest?.error, mockRequest?.url)
            return
        }
    }

    override func cancel() {
        onCompleteWithError?(mockRequest?.error, mockRequest?.url)
    }
}
