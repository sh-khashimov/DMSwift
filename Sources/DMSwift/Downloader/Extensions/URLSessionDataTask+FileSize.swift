//
//  URLSessionDataTask+FileSize.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/23/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

extension URLSessionDataTask {

    /// File size
    var fileSize: Int64 {
        var fileSize = self.countOfBytesExpectedToReceive
        if fileSize < 1 {
            fileSize = response?.contentLength ?? response?.expectedContentLength ?? fileSize
        }
        return fileSize
    }
}
