//
//  FileStorage.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 8/29/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// *FileStorage* responsible for saving and reading files.
public struct FileStorage: FileStorageManageable, FileWriting, FileReading {

    public var configuration: FileStorageConfiguration
    public let path: String?
    public let fileManager = FileManager()

    /// Initiliaze *FileStorage* with directory name and configuration
    /// - Parameter path: directory **path** name that will be used to store and retrieve files, if *nil*, will be used *searchPathDirectory* from **configuration** instead
    /// - Parameter fileStorageConfiguration: configuration
    public init(path: String? = nil, configuration: FileStorageConfiguration = DefaultFileStorageConfiguration()) {
        self.configuration = configuration
        self.path = path
    }
}
