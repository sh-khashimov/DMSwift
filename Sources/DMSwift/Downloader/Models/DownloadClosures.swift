//
//  DownloadClosures.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/26/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

public typealias DownloadFailedTask = (url: URL, error: Error?)

typealias SavedFileData = (location: URL?, filename: String?, fileExtension: String?)
typealias DownloadedFileData = (location: URL?, url: URL?, error: Error?)
typealias DownloadProgressData = (progress: Float, downloadedSize: Int64, receivedSize: Int64, fileSize: Int64)
