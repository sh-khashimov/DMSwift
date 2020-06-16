//
//  MockPostProcessDelegate.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/10/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import DMSwift

class MockPostProcessDelegate: PostProcessDelegate {

    public var onPostProcessStarted: (() -> Void)?

    public var onPostProcessCompleted: (() -> Void)?

    public var onProcessCompletedWithError: ((_ tasks: [DMSwiftTypealias.PostProcess.FailedTask]) -> Void)?

    public var onPostProcessUpdateTaskCount: ((_ progress: Float, _ finishedTaskCount: Int64, _ taskCount: Int64) -> Void)?

    func postProcessStarted() {
        onPostProcessStarted?()
    }

    func postProcessDidComplete() {
        onPostProcessCompleted?()
    }

    func postProcessDidUpdate(progress: Float, finishedTaskCount: Int64, taskCount: Int64) {
        onPostProcessUpdateTaskCount?(progress, finishedTaskCount, taskCount)
    }

    func postProcessDidCompletedWithError(tasks: [DMSwiftTypealias.PostProcess.FailedTask]) {
        onProcessCompletedWithError?(tasks)
    }


}
