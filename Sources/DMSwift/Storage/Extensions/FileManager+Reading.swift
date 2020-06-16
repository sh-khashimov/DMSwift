//
//  FileManager+Reading.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/14/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

public extension FileManager {

    /// File attributes
    /// - Parameter url: File or directory location `URL`.
    /// - Throws: `FileStorageError.fileNotFound`.
    /// - Returns: Return `FileAttributes` object.
    func fileAttributes(at url: URL) throws -> FileAttributes {
        guard let attributes = try? self.attributesOfItem(atPath: url.path) else { throw FileStorageError.fileNotFound(path: url.path) }
        let readOnly = (attributes[.appendOnly] as? NSNumber)?.boolValue
        let creationDate = attributes[.creationDate] as? Date
        let modificationDate = attributes[.modificationDate] as? Date
        let size = (attributes[.size] as? NSNumber)?.int64Value
        let type = attributes[.type] as? String
        let fileAttributes = FileAttributes(readOnly: readOnly, creationDate: creationDate, modificationDate: modificationDate, size: size, type: type)
        return fileAttributes
    }

    /// Search at a specified **directory** and return found objects.
    /// - Parameter directory: Search directory.
    /// - Parameter shouldEnumerateDirectories: Whether subdirectories should be enumerated.
    /// - Parameter includeDirectories: Whether directories should be included.
    /// - Parameter includeFiles: Whether files should be included.
    /// - Parameter includeHiddenFiles: Whether hidden files should be included.
    /// - Throws: `FileStorageError.invalidPath` - specified directory not found.
    /// - Returns: Return list of `URL`, that exists at a specified directory.
    func enumerate(directory: URL, enumerateDirectories: Bool = true, includeDirectories: Bool = false, includeFiles: Bool = true, includeHiddenFiles: Bool = false) -> [URL] {
        var resourceKeys = [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey]
        if includeFiles { resourceKeys.append(URLResourceKey.isRegularFileKey) }
        var options: FileManager.DirectoryEnumerationOptions = includeHiddenFiles ? [] : [.skipsHiddenFiles]
        if !enumerateDirectories { options.insert(.skipsSubdirectoryDescendants) }
        let directoryEnumerator = self.enumerator(at: directory,
                                                                     includingPropertiesForKeys: resourceKeys,
                                                                     options: options,
                                                                     errorHandler: nil)!
        var directories: [URL] = []

        for case let fileURL as URL in directoryEnumerator {
            let resourceValues = try? fileURL.resourceValues(forKeys: Set(resourceKeys))
            if let isDirectory = resourceValues?.isDirectory, isDirectory {
                if includeDirectories {
                    directories.append(fileURL)
                }
            } else if includeFiles {
                directories.append(fileURL)
            }
        }
        return directories
    }
}
