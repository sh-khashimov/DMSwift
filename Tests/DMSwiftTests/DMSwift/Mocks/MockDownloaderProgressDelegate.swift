//
//  MockDownloaderProgressDelegate.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/10/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import DMSwift

class MockDownloaderProgressDelegate: DownloaderProgressDelegate {

    var onDownloadUpdateSize: ((_ progress: Float, _ downloadedSize: Int64, _ totalSize: Int64) -> Void)?

    var onDownloadUpdateTaskCount: ((_ progress: Float, _ finishedTaskCount: Int64, _ taskCount: Int64) -> Void)?

    var onDownloadStarted: (() -> Void)?

    var onDownloadComplete: (() -> Void)?

    var onDownloadCompletedWithError: ((_ tasks: [DMSwiftTypealias.Download.FailedTask]) -> Void)?
    
    func downloadDidUpdate(progress: Float, downloadedSize: Int64, totalSize: Int64) {
        onDownloadUpdateSize?(progress, downloadedSize, totalSize)
    }

    func downloadDidUpdate(progress: Float, finishedTaskCount: Int64, taskCount: Int64) {
        onDownloadUpdateTaskCount?(progress, finishedTaskCount, taskCount)
    }

    func downloadStarted() {
        onDownloadStarted?()
    }

    func downloadDidComplete() {
        onDownloadComplete?()
    }

    func downloadDidCompletedWithError(tasks: [DMSwiftTypealias.Download.FailedTask]) {
        onDownloadCompletedWithError?(tasks)
    }


}
