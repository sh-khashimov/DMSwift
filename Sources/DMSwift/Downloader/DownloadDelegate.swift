//
//  DownloadDelegate.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 11/18/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// Download  delegate.
protocol DownloadDelegate: class {

    /// File size received.
    /// - Parameter fileSize: File size in bytes.
    func received(fileSize: Int64)

    /// Downloaded file size progress updated.
    /// - Parameters:
    ///   - progress: Progress.
    ///   - downloadedSize: Total downloaded size.
    ///   - receivedSize: New received size.
    ///   - fileSize: Total file size.
    func updated(_ progress: DMSwiftTypealias.Download.ProgressData)

    /// File download task completed.
    /// - Parameters:
    ///   - fileLocation: File location on the device storage.
    ///   - url: File remote location.
    ///   - error: Error.
    func completed(_ data: DMSwiftTypealias.Download.FileData)

    /// File saved to the device storage.
    /// - Parameter fileData: File location on the device storage, filename and extension.
    func fileData(_ fileData: DMSwiftTypealias.Download.SavedFileData)
}
