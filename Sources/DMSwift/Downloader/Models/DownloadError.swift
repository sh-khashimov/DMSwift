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
    case urlNotFound
    case invalidFilename
    case fileLocalURLCannotBeCreated
    case cannotMoveFile
    case invalidFileSize
}

extension DownloadError: LocalizedError {
    var errorDescription: String? {
        return nil
    }
}
