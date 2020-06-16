//
//  PostProcessLogging.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// logging functionality regarding Post-process
protocol PostProcessLogging where Self: Logging {}

extension PostProcessLogging {

    /// Logs when the post-process start.
    ///
    /// Log-level must be at least equal to medium.
    func postProcessStarted() {
        let message = "post-processes started"
        log(with: message, level: .medium)
    }

    /// Logs when the post-process finish.
    ///
    /// Log-level must be at least equal to medium.
    func postProcessCompleted() {
        let message = "post-processes completed"
        log(with: message, level: .medium)
    }

    /// Logs when post-process complete
    ///
    /// Log-level must be at least equal to medium.
    /// - Parameter failedTasks: Failed tasks.
    func postProcessCompleted(withFailledTasks failedTasks: [DMSwiftTypealias.PostProcess.FailedTask]) {
        var message = ""
        var failedTaskCount = 0
        for failedTask in failedTasks {
            failedTaskCount += 1
            var failedPostProcessCount = 0
            message += "[\(failedTaskCount)] file with location: \(failedTask.fileLocation) failed with post-processes: /n "

            for failedPostProcess in failedTask.process {
                failedPostProcessCount += 1
                message += "[\(failedPostProcess)] \(failedPostProcess.name) failed with error: \(failedPostProcess.error?.localizedDescription ?? "")  /n "
            }
        }
        log(with: message, level: .medium)
    }

    /// Logs when post-process change progress.
    ///
    /// Log-level must be at least equal to high.
    /// - Parameter progress: Post-process progress.
    func postProcessUpdated(withProgress progress: TaskProgress) {
        var message = "finished post-process task count: \(progress.finishedUnitCount), from: \(progress.totalUnitCount)"
        log(with: message, level: .high)
        message = "failled post-process task count: \(progress.failedUnitCount), from: \(progress.totalUnitCount)"
        log(with: message, level: .high)
        message = "post-process task progress: \(progress.progress*100) %"
        log(with: message, level: .high)
    }
}
