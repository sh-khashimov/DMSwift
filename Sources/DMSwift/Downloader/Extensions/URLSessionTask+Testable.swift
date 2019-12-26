//
//  URLSessionDataTaskProtocol.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 11/18/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

protocol URLSessionTaskTestable {
    func resume()
    func cancel()
}

extension URLSessionTask: URLSessionTaskTestable { }
