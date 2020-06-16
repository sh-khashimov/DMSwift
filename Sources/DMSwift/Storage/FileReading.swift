//
//  FileReading.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/4/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// Represent  file reading functionality that could be used within `FileStorageManageable`
public protocol FileReading: FileStorageManageable {}

public extension FileReading {

    /// Search file at a given directory or at `FileStorageManageable.directoryURL`, with given remote location of file **url**.
    ///
    /// Will search including all subdirectories.
    /// - Parameter url: File's remote location **url**.
    /// - Parameter directortyURL: Search directory, if *nil*, `FileStorageManageable.directoryURL` will be used instead.
    /// - Throws: `FileStorageError.invalidPath`,
    /// ` FileStorageError.invalidFileNameOrExtentision`,
    /// `FileStorageError.fileNotFound`
    ///  - Returns: File's storage location
    func searchFile(with url: URL, atDirectory directortyURL: URL? = nil) throws -> URL {
        if let filespec = try? filespec(at: url), let path = filespec.path {
            return URL(fileURLWithPath: path)
        }
        let fileData = url.filenameAndExtention(useHashedPathForFilename: self.configuration.useHashedPathForFilename)
        guard let filename = fileData.filename
            else { throw FileStorageError.invalidFileNameOrExtentision(path: url.path) }
        return try searchFile(withFilename: filename, fileExtention: fileData.extension, directortyURL: directortyURL).first!
    }


    /// Search file at a given directory or at `FileStorageManageable.directoryURL`, with given filename and file extension.
    /// - Parameters:
    ///   - filename: Filename.
    ///   - fileExtention: File extension.
    ///   - directortyURL: directory `URL`.
    func searchFile(withFilename filename: String, fileExtention: String? = nil, directortyURL: URL? = nil) throws -> [URL] {
        let _directoryURL = directortyURL ?? self.directoryURL
        guard let enumerator = fileManager.enumerator(atPath: _directoryURL.path)
            else { throw FileStorageError.invalidPath(path: _directoryURL.path) }
        var foundUrl: [URL] = []
        for case let _path as String in enumerator {
            guard _path.contains(filename) else { continue }
            let path = _directoryURL.appendingPathComponent(_path)

            guard let _fileExtention = fileExtention else {
                foundUrl.append(path)
                continue
            }

            let splittedPath = _path.split(separator: ".")
            guard splittedPath.count > 1, let fileExtension = splittedPath.last, _fileExtention == fileExtension else { continue }
            foundUrl.append(path)

        }
        if foundUrl.count > 0 {
            return foundUrl
        }
        throw FileStorageError.fileNotFound(path: nil)
    }

    /// Search file at a given directory or at `FileStorageManageable.directoryURL`, with given remote location of file **url**.
    ///
    /// Will search including all subdirectories.
    /// - Parameter url: File's remote location `URL`.
    /// - Parameter directortyURL: Search directory, if *nil*, `FileStorageManageable.directoryURL` will be used instead.
    /// - Throws: `FileStorageError.invalidPath`,
    /// ` FileStorageError.invalidFileNameOrExtentision`,
    /// `FileStorageError.fileNotFound`
    ///  - Returns: `Data` representation of a file
    func fileData(at url: URL, atDirectory directortyURL: URL? = nil) throws -> Data? {
        guard let fileLocation = try? searchFile(with: url, atDirectory: directortyURL) else { throw FileStorageError.fileNotFound(path: url.path) }
        return fileData(fileLocation)
    }

    /// Returns Data form given local file location
    /// - Parameter url: Local file location
    func fileData(_ url: URL) -> Data? {
        return fileManager.contents(atPath: url.path)
    }


    /// Search filespec object at a given directory or at `FileStorageManageable.directoryURL`, with given remote location of file **url**.
    ///
    /// Will search including all subdirectories.
    /// - Parameter url: File's remote location `URL`.
    /// - Parameter directortyURL: Search directory, if *nil*, `FileStorageManageable.directoryURL` will be used instead.
    /// - Throws: `FileStorageError.invalidPath`,
    /// ` FileStorageError.invalidFileNameOrExtentision`,
    /// `FileStorageError.fileNotFound`
    ///  - Returns: `Filespec` object
    func filespec(at url: URL, atDirectory directortyURL: URL? = nil) throws -> Filespec? {
        let _directoryURL = directortyURL ?? self.directoryURL
        let filename = url.absoluteString.MD5
        return try filespec(withFilename: filename, atDirectory: _directoryURL)
    }

    /// Search filespec object at a given directory or at `FileStorageManageable.directoryURL`, with given filename and file extension.
    /// - Parameters:
    ///   - filename: Filename.
    ///   - fileExtension: File extension.
    ///   - directortyURL: Directory `URL`.
    func filespec(withFilename filename: String, atDirectory directortyURL: URL? = nil) throws -> Filespec? {
        let _directoryURL = directortyURL ?? self.directoryURL
        var fileUrl = _directoryURL.appendingPathComponent(".\(filename)")
        let fileExtension = "json"
        fileUrl.appendPathExtension(fileExtension)
        guard fileManager.fileExists(atPath: fileUrl.path) else { throw FileStorageError.fileNotFound(path: fileUrl.path) }
        let data = fileManager.contents(atPath: fileUrl.path)!
        return Filespec(fromJsonData: data)
    }

    /// Returs list of filespepcs
    /// - Parameter directortyURL: Directory.
    func filespecs(atDirectory directortyURL: URL? = nil) throws -> [Filespec] {
        let _directoryURL = directortyURL ?? self.directoryURL
        var files = fileManager.enumerate(directory: _directoryURL, enumerateDirectories: false, includeDirectories: false, includeFiles: true, includeHiddenFiles: true)
        files = files.filter({ $0.pathExtension == "json" }).filter({ $0.lastPathComponent.starts(with: ".") })
        let filespecs = files.map({ Filespec(fromFilespecPath: $0.path) }).filter({ $0 != nil }).map({ $0! })
        return filespecs
    }

    /// List of directories at a given directory or at `FileStorageManageable.directoryURL`.
    /// - Parameter directortyURL: Search directory, if *nil*, `FileStorageManageable.directoryURL` will be used instead.
    /// - Throws: `FileStorageError.invalidPath`.
    ///  - Returns: List of directories as Array of `URL`.
    func directories(atDirectory directortyURL: URL? = nil) throws -> [URL] {
        let _directoryURL = directortyURL ?? self.directoryURL
        let directories = fileManager.enumerate(directory: _directoryURL, enumerateDirectories: false, includeDirectories: true, includeFiles: false)
        return directories
    }

    /// List of directories name at a given directory or at `FileStorageManageable.directoryURL`.
    /// - Parameter directortyURL: Search directory, if *nil*, `FileStorageManageable.directoryURL` will be used instead.
    /// - Throws: `FileStorageError.invalidPath`.
    ///  - Returns: List of directories `lastPathComponent`, as Array of `String`.
    func directoriesName(atDirectory directortyURL: URL? = nil) -> [String] {
        let _directoryURL = directortyURL ?? self.directoryURL
        let directories = (try? self.directories(atDirectory: _directoryURL)) ?? []
        return directories.map({$0.lastPathComponent})
    }


    /// List of files at a given directory or at `FileStorageManageable.directoryURL`.
    /// - Parameter enumerateDirectories: Whether subdirectories and their files should be included.
    /// - Parameter includeDirectories: Whether directories should be also returned.
    /// - Parameter directortyURL: Search directory, if *nil*, `FileStorageManageable.directoryURL` will be used instead.
    /// - Throws: `FileStorageError.invalidPath`.
    ///  - Returns: List of directories `lastPathComponent`, as Array of `String`.
    func filesIn(enumerateDirectories: Bool = true, includeDirectories: Bool = false, atDirectory directortyURL: URL? = nil) throws -> [URL] {
        let _directoryURL = directortyURL ?? self.directoryURL
        let files = fileManager.enumerate(directory: _directoryURL, enumerateDirectories: enumerateDirectories, includeDirectories: includeDirectories)
        return files
    }
}
