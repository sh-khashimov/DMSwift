//
//  URLRequestWrapper.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/10/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

struct URLRequestWrapper {
    var request: URLRequestTestable
}

extension URLRequestWrapper: Hashable {
    static func == (lhs: URLRequestWrapper, rhs: URLRequestWrapper) -> Bool {
        return lhs.request.url == rhs.request.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(request.url)
    }
}
