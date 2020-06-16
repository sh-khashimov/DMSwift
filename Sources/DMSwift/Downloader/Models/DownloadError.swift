//
//  DownloadError.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

enum DownloadError: Error {
    case cannotLoadFromNetwork(statusCode: Int)
    case invalidFilename(path: String?)
    case fileLocalURLCannotBeCreated(filename: String?, fileExtension: String?)
    case cannotMoveFile(path: String?, filename: String?, fileExtension: String?)
    case invalidFileSize // currently not used
}

extension DownloadError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cannotLoadFromNetwork(let statusCode):
            return "Network connection problem, status code: \(statusCode)"
        case .invalidFilename(let path):
        guard let path = path else {
            return "Failed to get filename."
        }
        return "Failed to get filename at the path: \(path)"
        case .fileLocalURLCannotBeCreated(let filename, let fileExtension):
            guard let filename = filename else {
                return "Unable to create file location url."
            }
            guard let fileExtension = fileExtension else {
                return "Unable to create file location url with filename: \(filename)."
            }
            return "Unable to create file location url with filename: \(filename) and file extension: \(fileExtension)."
        case .cannotMoveFile(let path, let filename, let fileExtension):
            guard let path = path else {
                return "Failed to move a file."
            }
            guard let filename = filename else {
                return "Failed to move a file to location: \(path)."
            }
            guard let fileExtension = fileExtension else {
                return "Failed to move a file to location: \(path), with filename: \(filename)."
            }
            return "Failed to move a file to location: \(path), with filename: \(filename) and file extension: \(fileExtension)."
        case .invalidFileSize:
            return "Invalid file size received."
        }
    }
}
