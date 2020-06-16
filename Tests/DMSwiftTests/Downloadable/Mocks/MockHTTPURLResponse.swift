//
//  MockHTTPURLResponse.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 11/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class MockHTTPURLResponse: HTTPURLResponse {

    override var expectedContentLength: Int64 {
        return _expectedContentLength
    }

    private var _expectedContentLength: Int64

    init?(URL url: URL, statusCode: Int, HTTPVersion: String?, headerFields: [String : String]?, expectedContentLength: Int64) {
        self._expectedContentLength = expectedContentLength
        
        super.init(url: url, statusCode: statusCode, httpVersion: HTTPVersion, headerFields: headerFields)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
