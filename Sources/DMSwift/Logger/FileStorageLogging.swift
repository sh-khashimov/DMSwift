//
//  FileStorageLogging.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

protocol FileStorageLogging where Self: Logging {}

extension FileStorageLogging {

    func fileCachedAtPath(_ path: String, from url: URL?) {
        let message = "file cached at path: \(path), from network: \(String(describing: url?.absoluteString))"
        log(with: message, level: .medium)
    }

    func cachedFilePath(_ path: String) {
        let message = "cached file path: \(path)"
        log(with: message, level: .medium)
    }
}
