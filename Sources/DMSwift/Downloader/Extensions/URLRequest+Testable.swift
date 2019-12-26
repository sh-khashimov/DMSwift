//
//  URLRequest+Testable.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 11/19/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

protocol URLRequestTestable {

    var url: URL? { get }

    func session(withTimeout timeout: TimeInterval, delegate: URLSessionDelegate?) -> URLSessionTestable
}

extension URLRequest: URLRequestTestable {
    func session(withTimeout timeout: TimeInterval, delegate: URLSessionDelegate? = nil) -> URLSessionTestable {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        return session as URLSessionTestable
    }
}
