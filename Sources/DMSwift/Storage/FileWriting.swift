//
//  FileWriting.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/4/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// Represent  file writing functionality that could be used within `FileStorageManageable`
public protocol FileWriting: FileStorageManageable {}

public extension FileWriting {


    /// Create a directory if does not exist.
    /// - Parameter url: pass directory **url** to create, in case if needed.
    /// Use `FileStorageManageable.urlFor(directory: String)` to create an url from relative directory path.
    func createDirectoryIfNeeded(_ url: URL? = nil) {
        let _url = url ?? directoryURL
        try? fileManager.createDirectoryIfNeeded(_url)
    }


    /// Save the file from **data** object to **directoryURL**, with given **filename** and **fileExtension**.
    ///
    ///  If **directoryURL** is *nil*, `FileStorageManageable.directoryURL` will be used.
    ///  The *directory* will be created in case if needed.
    ///  The file will be overridden if it already exists in the path.
    /// - Parameter data: Raw object to save.
    /// - Parameter directoryURL: **directoryURL** to save file.
    /// - Parameter filename: Filename.
    /// - Parameter fileExtension: File extension.
    /// - Throws: `FileStorageError.invalidPath`
    /// - Returns: Boolean of success.
    func createFile(from data: Data, toDirectory directoryURL: URL? = nil, filename: String, fileExtension: String? = nil) -> Bool {

        let _directoryPath = directoryURL ?? self.directoryURL

        createDirectoryIfNeeded(_directoryPath)

        var fileUrl = _directoryPath.appendingPathComponent(filename)

        if let fileExtension = fileExtension {
            fileUrl = fileUrl.appendingPathExtension(fileExtension)
        }

        //Remove file is exists.
        try? removeFile(fileUrl)

        let success = fileManager.createFile(atPath: fileUrl.path, contents: data, attributes: nil)
        return success
    }

    /// Save a JSON file from `Filespec` object.
    /// - Parameter filespec: **filespec** object that will be saved.
    /// - Parameter directoryURL: **directoryURL** to save file.
    /// - Returns: Boolean of success.
    func createFilespec(_ filespec: Filespec, toDirectory directoryURL: URL? = nil) -> Bool {
        let directoryURL = directoryURL ?? self.directoryURL
        if let filename = filespec.url?.absoluteString.MD5,
            let filespecData = filespec.jsonData {
            let success = self.createFile(from: filespecData, toDirectory: directoryURL, filename: ".\(filename)", fileExtension: "json")
            return success
        }
        return false
    }

    /// Rename or move file.
    /// - Parameter original: **original** file location in storage.
    /// - Parameter toURL: File new location `URL`.
    /// - Throws: `FileStorageError.invalidPath`
    func rename(original: URL, to toURL: URL) throws {
        try self.moveFile(at: original, to: toURL)
    }


    /// Rename or move file.
    /// - Parameter original: **original** file location in storage.
    /// - Parameter toURL: File new location `URL`.
    /// - Throws: `FileStorageError.invalidPath`
    func moveFile(at atURL: URL, to toURL: URL) throws {
        createDirectoryIfNeeded()
        try fileManager.moveItem(at: atURL, to: toURL)
    }

    /// Rename or move file.
    ///
    /// File will be saved to `FileStorageManageable.directoryURL`.
    /// - Parameter atURL: File location in storage.
    /// - Parameter toURL: To directory.
    /// - Parameter fileName: Filename.
    /// - Parameter fileExtension: File extension.
    func moveFile(at atURL: URL, to toDirectory: URL? = nil, withFileName fileName: String, fileExtension: String? = nil) throws -> URL {
        var toURL = (toDirectory ?? directoryURL).appendingPathComponent(fileName)
        if let fileExtension = fileExtension {
            toURL.appendPathExtension(fileExtension)
        }
        try self.moveFile(at: atURL, to: toURL)
        return toURL
    }

    // - TODO: need test and fix
    /// Removes file by filename.
    /// - Parameters:
    ///   - fileName: Filename.
    ///   - fileExtension: File extension.
    ///   - directoryURL: directory.
    func removeFile(fileName: String, fileExtension: String? = nil, at directoryURL: URL? = nil) throws {
        var fileUrl = (directoryURL ?? self.directoryURL).appendingPathComponent(fileName)
        if let fileExtension = fileExtension {
            fileUrl.appendPathExtension(fileExtension)
        }

        guard fileManager.fileExists(atPath: fileUrl.path) else { throw FileStorageError.fileNotFound }
        try fileManager.removeItem(atPath: fileUrl.path)
    }

    /// Removes a file.
    /// - Parameter url: File remote location.
    /// - Throws: `FileStorageError.invalidPath`,
    /// `FileStorageError.invalidFileNameOrExtentision`,
    /// `FileStorageError.fileNotFound`
    func removeFile(_ url: URL, at directoryURL: URL? = nil) throws {
        let fileData = url.filenameAndExtention(useHashedPathForFilename: self.configuration.useHashedPathForFilename)
        guard let filename = fileData.filename else { throw FileStorageError.invalidFileNameOrExtentision }
        var fileUrl = (directoryURL ?? self.directoryURL).appendingPathComponent(filename)
        if let fileExtension = fileData.extension {
            fileUrl.appendPathExtension(fileExtension)
        }
        guard fileManager.fileExists(atPath: fileUrl.path) else { throw FileStorageError.fileNotFound }
        try? removeFilespec(url, at: directoryURL)
        try fileManager.removeItem(atPath: fileUrl.path)
    }

    /// Removes Filespec.
    /// - Parameters:
    ///   - url: File remote location.
    ///   - directoryURL: directory.
    func removeFilespec(_ url: URL?, at directoryURL: URL? = nil) throws {
        guard let filename = url?.absoluteString.MD5 else { throw FileStorageError.invalidFileNameOrExtentision }
        let fileUrl = (directoryURL ?? self.directoryURL).appendingPathComponent(".\(filename)")
        guard fileManager.fileExists(atPath: fileUrl.path) else { throw FileStorageError.fileNotFound }
        try fileManager.removeItem(atPath: fileUrl.path)
    }

    /// Removes a file by file local location.
    /// - Parameter fileURL: File local location.
    func removeFile(at fileURL: URL) throws {
        try fileManager.removeItem(at: fileURL)
    }

    /// Remove `FileStorageManageable.searchDirectoryURL` that represent the `FileManager.SearchPathDirectory`.
    ///
    /// System will re-create *SearchPathDirectory*.
    /// - Attention: All files and folders will be deleted from specified *FileManager.SearchPathDirectory* including `FileStorageManageable.directoryURL`.
    /// Use with caution.
    /// - Throws: `FileStorageError.invalidPath`
    func removeFilesFromSearchDirectory() throws {
        try fileManager.removeAllFiles(atDirectory: searchDirectoryURL)
    }

    /// Remove `FileStorageManageable.directoryURL`.
    /// - Parameter directory: directory.
    /// - Throws: `FileStorageError.invalidPath`
    func removeDirectory(_ directory: URL? = nil) throws {
        try fileManager.removeItem(at: (directory ?? directoryURL))
    }

    /// Remove all files from `FileStorageManageable.directoryURL`.
    ///
    /// Directory self won't be removed.
    /// - Throws: `FileStorageError.invalidPath`
    func removeFilesFromDirectory() throws {
        try fileManager.removeAllFiles(atDirectory: directoryURL)
    }
}
