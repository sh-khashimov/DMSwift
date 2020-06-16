//
//  DownloadQueue.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/30/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// OperationQueue class, which is responsible for managing all download operations.
class DownloadQueue: OperationQueue {

    /// Progress.
    var downloadProgress = DownloadTaskProgress()

    /// The `Operation` object that used to report the completion of all running operations.
    var finishedOperation: Operation?

    /// List of tasks that failed.
    let failedTasks = SynchronizedArray<DMSwiftTypealias.Download.FailedTask>()

    /// Download type that passes to download operation.
    private var urlSessionTaskType: URLSessionTaskType

    /// File storage manager that passes to download operation.
    private var fileStorage: FileStorage

    /// Timeout interval that passes to download operation.
    private var timeoutIntervalForRequest: TimeInterval

    /// TODO: Temporary crutches
    /// Fix adding finishedOperation twice
    private var isFinishedOperationAdded: Bool = false

    /// Informs successful start of operations.
    public var onStarted: (() -> Void)?

    /// Informs on changes in progress.
    public var onTaskProgressUpdate: ((_ progress: DownloadTaskProgress) -> Void)?

    /// Informs on when downloaded size or total files size changes.
    public var onDownloadProgressUpdate: ((_ progress: DownloadTaskProgress) -> Void)?

    /// Informs when one of files will be saved.
    public var onFileSaveComplete: ((_ fileData: DMSwiftTypealias.Download.SavedFileData?) -> Void)?

    /// Informs completion of all operations.
    public var onComplete: ((_ failledTasks: [DMSwiftTypealias.Download.FailedTask]) -> Void)?

    /// Initiates with required parameters.
    /// - Parameters:
    ///   - configuration: Configuration to customize download process.
    ///   - fileStorage: File storage manager for files manipulations.
    init(configuration: DMSwiftConfiguration, fileStorage: FileStorage) {
        self.urlSessionTaskType = configuration.urlSessionTaskType
        self.timeoutIntervalForRequest = configuration.timeoutIntervalForRequest
        self.fileStorage = fileStorage
        super.init()
        self.name = configuration.downloadQueueName
        self.qualityOfService = configuration.downloadQueueQualityOfService
        self.maxConcurrentOperationCount = configuration.downloadMaxConcurrentOperationCount
        self.isSuspended = true
    }

    /// Updates `Self` with a new configuration.
    /// - Parameter downloaderConfiguration: A new configuration.
    func update(with downloaderConfiguration: DMSwiftConfiguration) {
        self.urlSessionTaskType = downloaderConfiguration.urlSessionTaskType
        self.timeoutIntervalForRequest = downloaderConfiguration.timeoutIntervalForRequest
        self.name = downloaderConfiguration.downloadQueueName
        self.qualityOfService = downloaderConfiguration.downloadQueueQualityOfService
        self.maxConcurrentOperationCount = downloaderConfiguration.downloadMaxConcurrentOperationCount
    }

    /// Updates `FileStorage`.
    /// - Parameter fileStorage: a new `FileStorage`
    func update(with fileStorage: FileStorage) {
        self.fileStorage = fileStorage
    }

    /// Method used to start all operations in the queue or add new operation to the queue.
    /// - Parameters:
    ///   - requests: The list of requests that are needed to create a list of download operations.
    ///   - completion: Completion handler that will be called where time when a download task will be finished.
    func start(_ requests: [URLRequestTestable], completion: ((_ fileData: DMSwiftTypealias.Download.FileData) -> Void)? = nil) {

        // suspend queue
        self.isSuspended = true

        // if there are no operations in the queue
        if self.operationCount == 0 {
            // add the start operation to the queue
            let downloadStartOperation = BlockOperation { [weak self] in
                self?.onStarted?()
            }

            self.addOperation(downloadStartOperation)
        }

        // if the finishedOperation does not exist
        if finishedOperation == nil {
            // create the finishedOperation
            finishedOperation = BlockOperation { [weak self] in
                self?.onComplete?(self?.failedTasks.synchronizedArray ?? [])
            }

            finishedOperation?.completionBlock = { [weak self] in
                self?.reset()
            }
        }

        for taskRequest in requests {
            // creates new download operation
            if let addedDownloadOperation = addDownloadOperation(taskRequest, completion) {
                // updates total download unit count
                self.downloadProgress.totalUnitCount += 1
                // add dependency to finishedOperation
                finishedOperation?.addDependency(addedDownloadOperation)
            }

        }

        // if finishedOperation not nil
        if let finishedOperation = finishedOperation,
            !isFinishedOperationAdded {
            // add finishedOperation to queue
            self.addOperation(finishedOperation)
            self.isFinishedOperationAdded = true
        }

        // unsuspend
        self.isSuspended = false
    }

    /// Add post-process operation to queue.
    /// - Parameters:
    ///   - request: Request for remote file location to crate a download operation.
    ///   - delegate: Optional download delegate.
    ///   - completion: Completion handler that will be called where time when a download task will be finished.
    private func addDownloadOperation(_ request: URLRequestTestable, delegate: DownloadDelegate? = nil, _ completion: ((_ fileData: DMSwiftTypealias.Download.FileData) -> Void)? = nil) -> Operation? {

        // no reason to go further if url is equal to nil))
        guard let url = request.url else { return nil }

        // creates download operation
        let downloadOperation = DownloadOperation(request, fileStorage: fileStorage, delegate: nil, downloadType: urlSessionTaskType, timeoutIntervalForRequest: timeoutIntervalForRequest, { [weak self] (fileLocation, _url, error) in

            // if has error
            if let error = error {
                // adds failed task and incrases failed unit count.
                self?.failedTasks.append((url: url, error: error))
                self?.downloadProgress.failedUnitCount += 1
            }
            else {
                // increases successfully finished unit count.
                self?.downloadProgress.finishedUnitCount += 1
            }

            // Informs about progress update.
            if let downloadProgress = self?.downloadProgress {
                self?.onTaskProgressUpdate?(downloadProgress)
            }

            // call completion in main thread.
            DispatchQueue.main.async {
                completion?((fileLocation, url, error))
            }
        })

        // updates files total size.
        downloadOperation.onReceiveFileSize = { [weak self] fileSize in
            guard let strongSelf = self else { return }
            strongSelf.downloadProgress.totalUnitFileSize += fileSize
            strongSelf.onDownloadProgressUpdate?(strongSelf.downloadProgress)
        }

        // updates total received files size.
        downloadOperation.onUpdateProgress = { [weak self] downloadProgressData in
            guard let strongSelf = self else { return }
            strongSelf.downloadProgress.totalUnitRecievedSize += downloadProgressData.receivedSize
            strongSelf.onDownloadProgressUpdate?(strongSelf.downloadProgress)
        }

        // called if a file successfully saved.
        downloadOperation.onFileDataChange = self.onFileSaveComplete

        // adds a name to download operation (just in case)
        downloadOperation.name = url.absoluteString.MD5
        //
        self.addOperation(downloadOperation)

        return downloadOperation
    }

    /// Resets parameters to the original value.
    private func reset() {
        downloadProgress.reset()
        failedTasks.clear()
        finishedOperation = nil
        isFinishedOperationAdded = false
    }
}
