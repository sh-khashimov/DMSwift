//
//  FileStorageError.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/4/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

public enum FileStorageError: Error {
    case invalidPath(path: String?)
    case invalidFileNameOrExtentision(path: String?)
    case fileNotFound(path: String?)
    case cannotDecodeRawData(objectType: String?) // currently not used
    case writeIOError // currently not used
}

extension FileStorageError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidPath(let path):
            guard let path = path else {
                return "Specified path not found."
            }
            return "Specified path (\(path)) not found."
        case .invalidFileNameOrExtentision(let path):
            guard let path = path else {
                return "Failed to get filename or file extension."
            }
            return "Failed to get filename or file extension at path: \(path)"
        case .fileNotFound(let path):
            guard let path = path else {
                return "File not found."
            }
            return "File not found at path: \(path)."
        case .cannotDecodeRawData(let objectType):
            guard let objectType = objectType else {
                return "Unable to decode data to specified object."
            }
            return "Unable to decode data to specified object (\(objectType))."
        case .writeIOError:
            return "Failed to write data to local disk."
        }
    }
}
