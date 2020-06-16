//
//  MockSessionDataTask.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 11/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

protocol URLSessionDataTaskTestable {
    var onDidReceive: ((_ fileSize: Int64, _ url: URL?) -> Void)? { get set }
    var onDidReceiveData: ((_ data: Data, _ url: URL?) -> Void)? { get set }
}

class MockSessionDataTask: URLSessionDataTask, URLSessionDataTaskTestable {

    var onDidReceiveData: ((Data, URL?) -> Void)?
    var onDidReceive: ((Int64, URL?) -> Void)?

    var mockRequest: MockRequest?

    private var _response: URLResponse?

    private let session = URLSession(configuration: URLSessionConfiguration.default)

    override var response: URLResponse? {
        return _response
    }

    override var originalRequest: URLRequest? {
        guard let url = mockRequest?.url else { return nil }
        return URLRequest(url: url)
    }

    override var countOfBytesExpectedToReceive: Int64 {
        return Int64(mockRequest?.data?.count ?? 0)
    }
    
    init(mockRequest: MockRequest?) {
        self.mockRequest = mockRequest
        self._response = mockRequest?.response
    }
    
    override func resume() {
        super.resume()
        let delegate = mockRequest?.session?.delegate as? URLSessionDataDelegate

        delegate?.urlSession?(session, dataTask: self as URLSessionDataTask, didReceive: self.response!, completionHandler: { (response) in
            //
        })

        let iteration = mockRequest?.iteration ?? 0
        for _ in 1...iteration {
            let data = Data(count: (mockRequest?.data?.count ?? 0)/iteration)
            delegate?.urlSession?(session, dataTask: self as URLSessionDataTask, didReceive: data)
        }
    }

    override func cancel() {
        let delegate = mockRequest?.session?.delegate as? URLSessionTaskDelegate

        let error = NSError(domain: "cancelled", code: 100, userInfo: nil)
        delegate?.urlSession?(session, task: self as URLSessionTask, didCompleteWithError: error)
    }
}
