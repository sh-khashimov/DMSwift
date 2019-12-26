//
//  URL+FilenameAndExtension.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/4/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

public extension URL {

    /// Creates `FilenameAlias` from `URL` object.
    /// - Parameter UseHashedPathForFilename: Whether or not should use MD5 hash of `URL` path for file name.
    /// - Returns: Return file remote located name, file name and extension.
    func filenameAndExtention(useHashedPathForFilename: Bool) -> FilenameAlias {
        guard self.pathComponents.count > 0 else { return (name: nil, filename: nil, extension: nil) }
        var unsafeName = self.deletingPathExtension().lastPathComponent
        if unsafeName.hasPrefix("/") {
            unsafeName = String(unsafeName.dropFirst())
        }
        if unsafeName.hasSuffix("/") {
            unsafeName = String(unsafeName.dropLast())
        }
        guard unsafeName.count > 0 else { return (name: nil, filename: nil, extension: nil) }
        let name = unsafeName
        let filename = useHashedPathForFilename ? self.absoluteString.MD5 : name
        var fileExtension: String? = nil
        if self.pathExtension.count > 0 {
            fileExtension = self.pathExtension
        }
        return (name: name, filename: filename, extension: fileExtension)
    }
}
