//
//  FileManager+Writing.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/14/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

public extension FileManager {

    /// Creates a directory, if directory not exist.
    /// - Parameter url: Directory location `URL`.
    func createDirectoryIfNeeded(_ url: URL) throws {
        guard !self.fileExists(atPath: url.path) else { return }
        try self.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
    }

    /// Remove all files at specified directory `URL`.
    /// - Parameter directoryURL: Directory `URL` where files located.
    /// - Throws: `FileStorageError.invalidPath` - specified directory not found.
    func removeAllFiles(atDirectory directoryURL: URL) throws {
        guard let directoryContents = try? self.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: []) else { throw FileStorageError.invalidPath }

        for fileURL in directoryContents {
            try? self.removeItem(at: fileURL)
        }
    }
}
