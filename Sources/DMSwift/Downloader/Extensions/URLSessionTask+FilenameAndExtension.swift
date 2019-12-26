//
//  URLSessionTask+FilenameAndExtension.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/17/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

public extension URLSessionTask {

    /// Creates `FilenameAlias` from `URL` object.
    /// - Parameter UseHashedPathForFilename: Whether or not should use MD5 hash of `URL` path for file name.
    /// - Returns: Return file remote located name, file name and extension.
    func filenameAndExtention(useHashedPathForFilename: Bool) -> FilenameAlias {
        let fileData = self.originalRequest?.url?.filenameAndExtention(useHashedPathForFilename: useHashedPathForFilename)
        var mimeTypeExtension: String? = nil
        if let mimeTypeLastString = self.response?.mimeType?.split(separator: "/").last {
            mimeTypeExtension = String(mimeTypeLastString)
        }
        let fileExtension = fileData?.extension ?? mimeTypeExtension
        return (name: fileData?.name, filename: fileData?.filename, extension: fileExtension)
    }
}
