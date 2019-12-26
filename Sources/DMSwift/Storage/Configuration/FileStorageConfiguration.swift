//
//  FileStorageConfiguration.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/3/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation


/// Configuration related to FileStorage.
///
/// Used to create a custom configuration container.
public protocol FileStorageConfiguration {

    /// The location of the directory in the Application sandbox.
    var searchPathDirectory: FileManager.SearchPathDirectory { get set }

    /// Used to indicate whether or not, should create  and store a Filespec data object.
    var createFilespec: Bool { get set  }

    /// Used to indicate whether or not, should use hashed (MD5) URL path for filename.
    var useHashedPathForFilename: Bool { get set }
}
