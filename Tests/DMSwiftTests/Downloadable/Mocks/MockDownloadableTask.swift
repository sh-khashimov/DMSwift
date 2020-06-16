//
//  TestableDownloadableTask.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/7/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
@testable import DMSwift


class MockDownloadableTask: DownloadableTask {

    var delegate: DownloadDelegate?

    var onUpdateProgress: ((DMSwiftTypealias.Download.ProgressData) -> Void)?

    var completionHandler: ((DMSwiftTypealias.Download.FileData) -> Void)?

    var onFileDataChange: ((DMSwiftTypealias.Download.SavedFileData) -> Void)?

    var onReciveFileSize: ((Int64) -> Void)?

    var fileStorage: FileStorage?

    var fileData: DMSwiftTypealias.Download.SavedFileData?

    var session: URLSessionTestable?

    var totalBytesWritten: Int64 = 0

    var fileSize: Int64 = 100

    var downloadType: URLSessionTaskType = .dataTask

    func start() { }

    func cancel() { }

    init() { }
}
