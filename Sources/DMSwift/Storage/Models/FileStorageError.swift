//
//  FileStorageError.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/4/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

public enum FileStorageError: Error {
    case invalidPath
    case invalidFileNameOrExtentision
    case fileNotFound
    case cannotDecodeRawData
    case writeIOError
}

extension FileStorageError: LocalizedError {
    public var errorDescription: String? {
        switch self {
//        case .imageMapping:
//            return "Failed to map data to an Image."
//        case .jsonMapping:
//            return "Failed to map data to JSON."
//        case .stringMapping:
//            return "Failed to map data to a String."
//        case .objectMapping:
//            return "Failed to map data to a Decodable object."
//        case .encodableMapping:
//            return "Failed to encode Encodable object into data."
//        case .statusCode:
//            return "Status code didn't fall within the given range."
//        case .underlying(let error, _):
//            return error.localizedDescription
//        case .requestMapping:
//            return "Failed to map Endpoint to a URLRequest."
//        case .parameterEncoding(let error):
//            return "Failed to encode parameters for URLRequest. \(error.localizedDescription)"
//        }
        case .invalidPath:
            return ""
        case .invalidFileNameOrExtentision:
            return ""
        case .fileNotFound:
            return ""
        case .cannotDecodeRawData:
            return ""
        case .writeIOError:
            return ""
        }
    }
}
