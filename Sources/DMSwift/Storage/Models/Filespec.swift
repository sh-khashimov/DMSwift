//
//  FileSpec.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 8/29/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation


/// Filespec expected to store a file related information that could be not available after how a file was downloaded.
/// Filespec object could be stored in .json format representation.
///
/// Filespec can be useful in some situations, for example, let say you have a path to a local file, but you also want to know from where that file was downloaded.
public struct Filespec: Codable {

    /// **url** from where the file was downloaded
    public var url: URL?

    /// **directoryPath** where the file is located in the device
    public var directoryPath: String?

    /// original given **name** to the file
    public var name: String?

    /// **filename** that stores in the device
    public var filename: String?

    /// File's extention
    public var fileExtension: String?

    /// File size, in bytes
    public var size: Int64?

    /// The location of the directory in the Application sandbox
    public var searchPathDirectoryId: UInt?
}

public extension Filespec {

    /// full **path** where the file is located in the device
    var path: String? {
        guard let searchPathDirectoryId = self.searchPathDirectoryId else { return nil }
        guard let searchPathDirectory = FileManager.SearchPathDirectory.init(rawValue: searchPathDirectoryId) else { return nil }
        let fileManager = FileManager()
        guard let searchDirectoryURL = fileManager.urls(for: searchPathDirectory, in: .userDomainMask).first else { return nil }
        guard let directoryPath = self.directoryPath else { return nil }
        var filePath = searchDirectoryURL.appendingPathComponent(directoryPath, isDirectory: true)
        if let filename = self.filename {
            filePath.appendPathComponent(filename)
        } else if let name = self.name {
            filePath.appendPathComponent(name)
        }
        if let fileExtension = self.fileExtension {
            filePath.appendPathExtension(fileExtension)
        }
        return filePath.path
    }
}


public extension Filespec {

    /// **Data** representation of **Filespec** in JSON format
    var jsonData: Data? {
        try? JSONEncoder().encode(self)
    }

    /// Initialization of **Filespec**
    /// - Parameter jsonData: **Data** that represent **Filespec** in JSON format
    init?(fromJsonData jsonData: Data) {
        do {
            self = try JSONDecoder().decode(Filespec.self, from: jsonData)
        } catch {
            return nil
        }
    }

    /// Creates a **Filespec**
    /// - Parameter path: **path** where a **Filespec** file located
    init?(fromFilespecPath path: String) {
        let url = URL(fileURLWithPath: path)
        do {
            self = try JSONDecoder().decode(Filespec.self, from: Data(contentsOf: url))
        } catch {
            return nil
        }
    }

    /// Creates a **Filespec**
    /// - Parameters:
    ///   - url: **url** from where the file was downloaded
    ///   - path: **path** where the file is located in the device
    ///   - name: original given **name** to the file
    ///   - filename: **filename** that stores in the device
    ///   - fileExtension: File's extention
    ///   - size: File size, in bytes
    ///   - searchPathDirectoryId: The location of the directory in the Application sandbox
    init(url: URL?, path: String?, name: String?, filename: String?, fileExtension: String?, size: Int64?, searchPathDirectoryId: UInt?) {
        self.url = url
        self.directoryPath = path
        self.name = name
        self.filename = filename
        self.fileExtension = fileExtension
        self.size = size
        self.searchPathDirectoryId = searchPathDirectoryId
    }
}

extension Filespec: Equatable {}
