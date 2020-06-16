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

    /// Informs when downloaded size or total files size changes.
    /// - Parameters:
    ///   - progress: Progress as a percentage.
    ///   - downloadedSize: Total downloaded size.
    ///   - totalSize: Total files size.
    func downloadDidUpdate(progress: Float, downloadedSize: Int64, totalSize: Int64)

    /// Informs on changes in download task count progress.
    /// - Parameters:
    ///   - progress: Progress as a percentage.
    ///   - finishedTaskCount: Finished task count.
    ///   - taskCount: Total running task count.
    func downloadDidUpdate(progress: Float, finishedTaskCount: Int64, taskCount: Int64)

    /// Informs when download operations started.
    func downloadStarted()

    /// Informs when all download operations finished successfully.
    func downloadDidComplete()

    /// Informs when downloaded operations finished and some of them have errors.
    /// - Parameter tasks: Failed to complete tasks.
    func downloadDidCompletedWithError(tasks: [DMSwiftTypealias.Download.FailedTask])
}
