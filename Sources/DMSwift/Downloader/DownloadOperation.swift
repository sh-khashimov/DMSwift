//
//  DownloadOperation.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 9/5/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// The operation responsible for downloading the file.
///
/// Initiates with `URLSessionTaskType` as **downloadType**.
/// It has two options for downloading a file, via `URLSessionDownloadTask` or `URLSessionDataTask`.
/// If **downloadType** is equal to *downloadTask*,
/// then downloading will be implemented through `URLSessionDownloadTask`,
/// otherwise through `URLSessionDataTask`.
/// In terms of performance, both options work the same way.
/// At the moment there is not much difference, however,
/// when downloading via `URLSessionDownloadTask`,
/// if the response does not contain the *"Content-Length" header*,
/// then the file size in progress will be empty,
/// while `URLSessionDataTask` always has the file size.
/// If you need progress according to the file size and response header doesn't contain *"Content-Length"*,
/// then use `URLSessionDataTask`, otherwise, try to always use `URLSessionDownloadTask`.
/// In the future, more features will probably be added for each type of download.
/// For example, support for resuming download or the ability to download in the background.
class DownloadOperation: DefaultOperation {

    override var isAsynchronous: Bool {
        return true
    }

    var onReciveFileSize: ((_ fileSize: Int64) -> Void)? {
        didSet {
            downloadTask?.onReciveFileSize = self.onReciveFileSize
        }
    }

    var onUpdateProgress: ((DownloadProgressData) -> Void)? {
        didSet {
            downloadTask?.onUpdateProgress = self.onUpdateProgress
        }
    }

    /// The file data saved.
    var onFileDataChange: ((_ fileData: SavedFileData?) -> Void)? {
        didSet {
            downloadTask?.onFileDataChange = self.onFileDataChange
        }
    }

    private(set) var downloadTask: DownloadableTask?

    /// Initiates with required parameters.
    /// - Parameters:
    ///   - url: File remote location.
    ///   - fileStorage: File storage manager.
    ///   - delegate: Progress delegate.
    ///   - downloadType: Download type.
    ///   - timeoutIntervalForRequest: Request timeout interval.
    ///   - completionHandler: Complete handler.
    convenience init(_ url: URLTestable, fileStorage: FileStorage, delegate: DownloadDelegate? = nil, downloadType: URLSessionTaskType, timeoutIntervalForRequest: TimeInterval,
                     _ completionHandler: ((DownloadedFileData) -> Void)? = nil) {

        self.init(url.urlRequest, fileStorage: fileStorage, delegate: delegate, downloadType: downloadType, timeoutIntervalForRequest: timeoutIntervalForRequest, completionHandler)
    }

    /// Initiates with required parameters.
    /// - Parameters:
    ///   - request: Remote request to the file.
    ///   - fileStorage: File storage manager.
    ///   - delegate: Progress delegate.
    ///   - downloadType: Download type.
    ///   - timeoutIntervalForRequest: Request timeout interval.
    ///   - completionHandler: Complete handler.
    init(_ request: URLRequestTestable, fileStorage: FileStorage, delegate: DownloadDelegate? = nil, downloadType: URLSessionTaskType, timeoutIntervalForRequest: TimeInterval,
         _ completionHandler: ((DownloadedFileData) -> Void)? = nil) {

        downloadTask = DownloadTask(request, fileStorage: fileStorage, delegate: delegate, downloadType: downloadType, timeoutIntervalForRequest: timeoutIntervalForRequest)

        super.init()

        downloadTask?.completionHandler = { [weak self] downloadedFileData in
            completionHandler?(downloadedFileData)
            self?.state = .finished
        }

        if request.url == nil {
            self.cancel()
        }
    }

    override func start() {
        if(self.isCancelled) {
            self.cancel()
            return
        }

        // start the downloading
        downloadTask?.start()

        state = .executing
    }

    override func cancel() {
        // cancel the downloading
        downloadTask?.cancel()
        downloadTask = nil
        state = .finished
    }

}
