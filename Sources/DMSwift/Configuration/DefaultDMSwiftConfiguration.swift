//
//  DefaultDMSwiftConfiguration.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 11/1/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// Used as default `DownloaderConfiguration`.
public struct DefaultDMSwiftConfiguration: DMSwiftConfiguration {

    public var downloadMaxConcurrentOperationCount: Int = 10

    public var downloadQueueQualityOfService: QualityOfService = .background

    public var urlSessionTaskType: URLSessionTaskType = .downloadTask

    public var timeoutIntervalForRequest: TimeInterval = 100

    public var postProcessMaxConcurrentOperationCount: Int = 3

    public var postProcessQueueQualytyOfService: QualityOfService = .background

    public var startPostProcessQueueConcurrentlyToDownloadQueue: Bool = true

    public init() { }
}
