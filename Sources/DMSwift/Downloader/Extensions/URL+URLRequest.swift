//
//  URL+URLRequest.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/28/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

protocol URLTestable {
    var urlRequest: URLRequestTestable { get }
}

extension URL {

    /// Represent `URLRequest` from `URL` object.
    var urlRequest: URLRequestTestable {
        var request = URLRequest(url: self)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        return request as URLRequestTestable
    }
}
