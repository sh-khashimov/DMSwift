//
//  FileAttributes.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/7/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation


/// Describes the attributes of the file
public struct FileAttributes {

    /// Whether or not, file is read only.
    public var readOnly: Bool?

    /// File created date.
    public var creationDate: Date?

    /// File modificated date.
    public var modificationDate: Date?

    /// File size.
    public var size: Int64?

    /// File type.
    /// Symbolic Link, Folder etc.
    public var type: String?
}
