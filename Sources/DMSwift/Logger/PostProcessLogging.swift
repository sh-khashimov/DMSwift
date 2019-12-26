//
//  PostProcessLogging.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

protocol PostProcessLogging where Self: Logging {}

extension PostProcessLogging {

    func postProcessStarted() {
        let message = "post-processes started"
        log(with: message, level: .medium)
    }

    func postProcessCompleted() {
        let message = "post-processes completed"
        log(with: message, level: .medium)
    }

    func postProcessCompleted(withFailledTasks failedTasks: [PostProcessFailedTask]) {
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

    func postProcessUpdated(withProgress progress: TaskProgress) {
        var message = "finished post-process task count: \(progress.finishedUnitCount), from: \(progress.totalUnitCount)"
        log(with: message, level: .high)
        message = "failled post-process task count: \(progress.failedUnitCount), from: \(progress.totalUnitCount)"
        log(with: message, level: .high)
        message = "post-process task progress: \(progress.progress*100) %"
        log(with: message, level: .high)
    }
}
