//
//  FileStorageLogging.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// logging functionality regarding file storage
protocol FileStorageLogging where Self: Logging {}

extension FileStorageLogging {

    /// Logs when file cached
    ///
    /// Log-level must be at least equal to medium.
    /// - Parameters:
    ///   - path: A path where file is cached.
    ///   - url: A url from file was downloaded.
    func fileCachedAtPath(_ path: String, from url: URL?) {
        let message = "file cached at path: \(path), from network: \(String(describing: url?.absoluteString))"
        log(with: message, level: .medium)
    }

    /// Logs when file cached
    ///
    /// Log-level must be at least equal to medium.
    /// - Parameter path: A path where file is cached.
    func cachedFilePath(_ path: String) {
        let message = "cached file path: \(path)"
        log(with: message, level: .medium)
    }
}
