//
//  TaskProgress.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/29/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

public protocol TaskProgressCounting {
    var totalUnitCount: Int64 { get set }
    var finishedUnitCount: Int64 { get set }
    var failedUnitCount: Int64 { get set }
}

public extension TaskProgressCounting {
    var isFinished: Bool {
        return finishedUnitCount + failedUnitCount >= totalUnitCount
    }

    var progress: Float {
        guard totalUnitCount != 0 else { return 0 }
        return Float(finishedUnitCount) / Float(totalUnitCount)
    }

    mutating func reset() {
        totalUnitCount = 0
        finishedUnitCount = 0
        failedUnitCount = 0
    }
}

public protocol FileDownloadProgressCounting: TaskProgressCounting  {
    var totalUnitFileSize: Int64 { get set }
    var totalUnitRecievedSize: Int64 { get set }
}

public extension FileDownloadProgressCounting {
    var isFinishedDownload: Bool {
        return finishedUnitCount + failedUnitCount >= totalUnitCount
    }

    var downloadProgress: Float {
        return Float(totalUnitFileSize) / Float(totalUnitRecievedSize)
    }

    mutating func reset() {
        totalUnitCount = 0
        finishedUnitCount = 0
        failedUnitCount = 0
        totalUnitFileSize = 0
        totalUnitRecievedSize = 0
    }
}

public struct TaskProgress: TaskProgressCounting {
    public var totalUnitCount: Int64 = 0
    public var finishedUnitCount: Int64 = 0
    public var failedUnitCount: Int64 = 0
}

public struct DownloadTaskProgress: FileDownloadProgressCounting {
    public var totalUnitCount: Int64 = 0
    public var finishedUnitCount: Int64 = 0
    public var failedUnitCount: Int64 = 0
    public var totalUnitFileSize: Int64 = 0
    public var totalUnitRecievedSize: Int64 = 0
}
