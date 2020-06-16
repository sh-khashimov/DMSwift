//
//  PostProcessDelegate.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 11/18/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// Post-process delegate
public protocol PostProcessDelegate: class {

    /// Informs when post-processing operations started.
    func postProcessStarted()

    /// Informs when all post-processing operations finished successfully.
    func postProcessDidComplete()

    /// Informs on changes in post-process operations count progress.
    /// - Parameters:
    ///   - progress: Progress.
    ///   - finishedTaskCount: Finished task count.
    ///   - taskCount: Total running task count.
    func postProcessDidUpdate(progress: Float, finishedTaskCount: Int64, taskCount: Int64)

    /// Informs when post-processing operations finished and some of them have errors.
    /// - Parameter tasks: Failed to complete tasks.
    func postProcessDidCompletedWithError(tasks: [DMSwiftTypealias.PostProcess.FailedTask])
}
