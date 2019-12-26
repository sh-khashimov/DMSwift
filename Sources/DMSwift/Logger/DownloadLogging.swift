//
//  DownloadLogging.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

protocol DownloadLogging where Self: Logging {}

extension DownloadLogging {

    func downloadStarted() {
        let message = "downloads started"
        log(with: message, level: .medium)
    }

    func downloadCompleted() {
        let message = "downloads completed"
        log(with: message, level: .medium)
    }

    func downloadsCompleted(withFailledTasks failedTasks: [(url: URL, error: Error?)]) {
        var message = ""
        var count = 0
        for failedTask in failedTasks {
            count += 1
            message += "[\(count)] download failed with error: \(failedTask.error?.localizedDescription ?? ""), at URL: \(failedTask.url) /n "
        }
        log(with: message, level: .medium)
    }

    func downloadTaskUpdated(withProgress progress: DownloadTaskProgress) {
        var message = "finished download task count: \(progress.finishedUnitCount), from: \(progress.totalUnitCount)"
        log(with: message, level: .high)
        message = "failled download task count: \(progress.failedUnitCount), from: \(progress.totalUnitCount)"
        log(with: message, level: .high)
        message = "download task progress: \(progress.progress*100) %"
        log(with: message, level: .high)
    }

    func downloadFileUpdated(withProgress progress: DownloadTaskProgress) {
        var message = "downloaded size: \(progress.totalUnitRecievedSize), from: \(progress.totalUnitFileSize)"
        log(with: message, level: .high)
        message = "download size progress: \(progress.downloadProgress*100) %"
        log(with: message, level: .high)
    }

    func downloadError(_ error: Error, from url: URL?) {
        let message = "\(error.localizedDescription), with url: \(String(describing: url?.absoluteString))"
        log(with: message, level: .low)
    }
}
