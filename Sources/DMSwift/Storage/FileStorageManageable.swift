//
//  FileStorageManageable.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/31/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// *FileStorageManageable* represent an implementation of "File" storage related functionality.
///
/// Could be used as a blueprint for creating an object that behaves like a **File Manager**.
/// See also _FileWriting_ and _FileReading_ protocol.
public protocol FileStorageManageable {

    /// **configuration**
    var configuration: FileStorageConfiguration { get }

    /// relative directory **path** that will be used to store and retrieve files.
    var path: String? { get }

    /// FileManager object from Foundation.
    var fileManager: FileManager { get }
}

// -MARK: Computed variables
public extension FileStorageManageable {


    /// *URL* representation of *SearchPathDirectory* that could be customized in configuration.
    var searchDirectoryURL: URL {
        return fileManager.urls(for: configuration.searchPathDirectory, in: .userDomainMask).first!
    }

    /// *URL* representation of the **directory** name.
    /// If the directory **path** is *nil*, **searchDirectoryURL** will be returned.
    var directoryURL: URL {
        let documentsDirectory = searchDirectoryURL
        guard let path = self.path else { return documentsDirectory }
        let directoryUrl = documentsDirectory.appendingPathComponent(path, isDirectory: true)
        return directoryUrl
    }
}

// -MARK: Convertable methods
public extension FileStorageManageable {

    /// Convert to *URL* from relative *directory (folder)* path.
    /// - Parameter directoryPath: **directory** path that will be represented.
    func urlFor(directoryPath: String) -> URL {
        let directoryUrl = directoryURL.appendingPathComponent(directoryPath)
        return directoryUrl
    }

    /// Convert to *URL* from file *name* and *extension* that relative to *directory* path.
    /// - Parameter filename: File name.
    /// - Parameter fileExtension: File extension.
    /// - Parameter directory: directory.
    func urlFor(filename: String, fileExtension: String? = nil, at directory: URL? = nil) -> URL {
        var fileUrl = (directory ?? directoryURL).appendingPathComponent(filename)
        if let _fileExtension = fileExtension {
            fileUrl = fileUrl.appendingPathExtension(_fileExtension)
        }
        return fileUrl
    }


    /// Convert to *URL* from file remote location *URL* relative to *directory* path.
    /// - Parameters:
    ///   - url: File remove location.
    ///   - directory: directory.
    func urlFor(_ url: URL, at directory: URL? = nil) -> URL? {
        let filenameData = url.filenameAndExtention(useHashedPathForFilename: configuration.useHashedPathForFilename)
        guard let filename = filenameData.filename else { return nil }
        var fileUrl = (directory ?? directoryURL).appendingPathComponent(filename)
        if let fileExtension = filenameData.extension {
            fileUrl = fileUrl.appendingPathExtension(fileExtension)
        }
        return fileUrl
    }
}
