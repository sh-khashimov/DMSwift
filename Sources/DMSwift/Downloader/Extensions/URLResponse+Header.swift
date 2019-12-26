//
//  URLResponse+Header.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/23/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

extension URLResponse {

    /// File size from HTTP header - Content-Length
    var contentLength: Int64? {
        guard let httpResponse = self as? HTTPURLResponse else { return nil }
        let contentLength = Int64(httpResponse.allHeaderFields["Content-Length"] as? String ?? "")
        return contentLength
    }

    /// Creates file name related data.
    /// - Parameter useHashedPathForFilename: Whether or not should use MD5 hash of `URL` path for file name.
    func filenameAlias(useHashedPathForFilename: Bool, requestUrl: URL? = nil) -> FilenameAlias? {

        var filename: String? = nil
        var name: String? = nil
        var fileExtension: String? = nil

        // creates file name related data from URL path, for alternative
        let filenameAliasFromUrl = (requestUrl ?? url)?.filenameAndExtention(useHashedPathForFilename: useHashedPathForFilename)

        // if response is HTTP URL Response
        if let httpResponse = self as? HTTPURLResponse {
            // Content-Disposition header information
            let contentDisposition = httpResponse.allHeaderFields["Content-Disposition"] as? String

            // filename prefix to find a filename from Content-Disposition
            let filenamePrefix = "filename="

            // search filename
            if let range = contentDisposition?.range(of: "\(filenamePrefix)\".+\"",
                              options: .regularExpression) {
                // removes prefix and suffix
                filename = contentDisposition?[range]
                    .replacingOccurrences(of: filenamePrefix, with: "")
                    .replacingOccurrences(of: "\"", with: "")
            }

            // if filename found
            if let filename = filename {
                // split the found filename
                let nameWithExtension = filename.split(separator: ".")
                // if filename contains file extension, if not, name is equal to filename
                if nameWithExtension.count > 1, let _extension = nameWithExtension.last {
                    fileExtension = String(_extension)
                    let names = nameWithExtension.dropLast()
                    name = names.joined()
                } else {
                    name = filename
                }
            }

            // if filename should be MD5 hash
            if useHashedPathForFilename {
                filename = filenameAliasFromUrl?.filename
            }

            // if the file extension is undefined
            if fileExtension == nil {
                // will try get file extension from Content-Type header
                let contentType = httpResponse.allHeaderFields["Content-Type"] as? String
                if let range = contentType?.range(of: "/.+;", options: .regularExpression),
                    let _extension = contentType?[range].dropFirst().dropLast() {
                    fileExtension = String(_extension)
                } else if let range = contentType?.range(of: "/.+", options: .regularExpression),
                    let _extension = contentType?[range].dropFirst() {
                    fileExtension = String(_extension)
                }
            }
        }

        return (name: name ?? filenameAliasFromUrl?.name, filename: filename ?? filenameAliasFromUrl?.filename, extension: fileExtension ?? filenameAliasFromUrl?.extension)
    }
}
