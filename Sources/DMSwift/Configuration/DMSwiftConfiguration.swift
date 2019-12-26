//
//  DMSwiftConfiguration.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/3/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// Customizable configuration.
public protocol DMSwiftConfiguration {

    /// Maximum download operations that should start concurrently.
    var downloadMaxConcurrentOperationCount: Int { get set }

    /// `QualityOfService` for `DownloadQueue`.
    var downloadQueueQualityOfService: QualityOfService { get set }

    /// `URLSessionTaskType` that will be used during file download.
    var urlSessionTaskType: URLSessionTaskType { get set }

    /// Timeout for remote request. Used only if passed `URL` as source of file.
    var timeoutIntervalForRequest: TimeInterval { get set }

    /// Maximum post processing operations that should start concurrently.
    var postProcessMaxConcurrentOperationCount: Int { get set }

    /// `QualityOfService` for `PostProcessQueue`.
    var postProcessQueueQualytyOfService: QualityOfService { get set }

    /// Whether or not, should start `PostProcessQueue` concurrently to `DownloadQueue`.
    /// If *false*,  `PostProcessQueue` will be started after `DownloadQueue` finish.
    var startPostProcessQueueConcurrentlyToDownloadQueue: Bool { get set }
}

public extension DMSwiftConfiguration {

    /// Donwload queue name.
    ///
    /// Optional.
    var downloadQueueName: String {
        // TODO: change com.downloader to project name.
        return "com.downloader.downloadQueueName"
    }

    /// Post process queue name.
    ///
    /// Optional.
    var postProcessingQueueName: String {
        return "com.downloader.postProcessingQueue"
    }
}
