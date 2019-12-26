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
    /// Default is document directory.
    public var searchPathDirectory: FileManager.SearchPathDirectory = .documentDirectory

    /// Whether or not, should create and save a `Filespec`.
    public var createFilespec: Bool = true

    /// Whether or not, should use hashed MD5 path for filename.
    public var useHashedPathForFilename: Bool = false

    public init() { }

}
