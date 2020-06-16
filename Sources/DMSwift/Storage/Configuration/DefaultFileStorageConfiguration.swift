//
//  DefaultFileStorageConfiguration.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/4/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation


/// Implementation of *FileStorageConfiguration* that used as a default configuration  container object.
public struct DefaultFileStorageConfiguration: FileStorageConfiguration {

    /// The path to the root directory.
    ///
    /// Default value is document directory. On **macOS** or **Linux** default value is cachesDirectory.
    public var searchPathDirectory: FileManager.SearchPathDirectory

    /// Whether should create and save a `Filespec`.
    public var createFilespec: Bool = true

    /// Whether to use hashed MD5 path for a filename.
    public var useHashedPathForFilename: Bool = false

    public init() {
        #if os(macOS) || os(Linux)
        searchPathDirectory = .cachesDirectory
        #else
        searchPathDirectory = .documentDirectory
        #endif
    }

}
