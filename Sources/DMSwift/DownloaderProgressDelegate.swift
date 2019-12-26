//
//  DownloaderProgressDelegate.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 11/18/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// Download progress delegate.
public protocol DownloaderProgressDelegate: class {

    /// Reports when downloaded size or total files size changes.
    /// - Parameters:
    ///   - progress: Progress.
    ///   - downloadedSize: Total downloaded size.
    ///   - totalSize: Total files size.
    func downloadDidUpdate(progress: Float, downloadedSize: Int64, totalSize: Int64)

    /// Reports when downloaded size or total files size changes.
    /// - Parameters:
    ///   - progress: Progress.
    ///   - finishedTaskCount: Finished task count.
    ///   - taskCount: Total running task count.
    func downloadDidUpdate(progress: Float, finishedTaskCount: Int64, taskCount: Int64)

    /// Reports when download operations started.
    func downloadStarted()

    /// Reports when all download operations finished.
    func downloadDidComplete()

    /// Reports when downloaded operations finished and some of them have errors.
    /// - Parameter tasks: Failed to complete tasks.
    func downloadDidCompletedWithError(tasks: [DownloadFailedTask])
}
