//
//  PostProcessingQueue.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/30/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// OperationQueue class, which is responsible for managing all post-processing operations.
class PostProcessQueue: OperationQueue {

    /// List of all available post-preccesses.
    private var postProcesses: [PostProcessing]

    /// The file storage manager used to pass to a PostProcessing object.
    private var fileStorage: FileStorage

    /// Progress.
    private var postProcessProgress = TaskProgress()

    /// Whether the post-process will be in concurrency to download queue.
    var postProcessInConcurrencyToDownloadQueue: Bool

    /// The `Operation` object that used to report the completion of all running operations.
    var finishedOperation: Operation?

    /// TODO: Temporary crutches
    /// Fix adding finishedOperation twice
    private var isFinishedOperationAdded: Bool = false

    /// List of tasks that failed.
    let failedTasks = SynchronizedArray<DMSwiftTypealias.PostProcess.FailedTask>()

    /// Informs successful start of operations.
    public var onStarted: (() -> Void)?

    /// Informs on changes in progress.
    public var onTaskProgressUpdate: ((_ progress: TaskProgress) -> Void)?

    /// Informs completion of all operations.
    public var onComplete: ((_ failledTasks: [DMSwiftTypealias.PostProcess.FailedTask]) -> Void)?

    /// Initiates with required parameters.
    /// - Parameters:
    ///   - configuration: `DownloaderConfiguration` used to get preferred configuration.
    ///   - fileStorage: The file storage manager that used to pass to a `PostProcessing` object.
    ///   - postProcessings: Available post-processes.
    init(configuration: DMSwiftConfiguration, fileStorage: FileStorage, postProcessings: [PostProcessing]) {
        self.postProcesses = postProcessings
        self.postProcessInConcurrencyToDownloadQueue = configuration.startPostProcessQueueConcurrentlyToDownloadQueue
        self.fileStorage = fileStorage
        super.init()
        self.name = configuration.postProcessingQueueName
        self.qualityOfService = configuration.postProcessQueueQualytyOfService
        self.maxConcurrentOperationCount = configuration.postProcessMaxConcurrentOperationCount
        self.isSuspended = true
    }

    /// Updates `Self` with the `DMSwiftConfiguration`
    /// - Parameter dmSwiftConfiguration: Customizable configuration.
    func update(with dmSwiftConfiguration: DMSwiftConfiguration) {
        self.postProcessInConcurrencyToDownloadQueue = dmSwiftConfiguration.startPostProcessQueueConcurrentlyToDownloadQueue
        self.name = dmSwiftConfiguration.postProcessingQueueName
        self.qualityOfService = dmSwiftConfiguration.postProcessQueueQualytyOfService
        self.maxConcurrentOperationCount = dmSwiftConfiguration.postProcessMaxConcurrentOperationCount
    }

    /// Updates **postProcesses**
    /// - Parameter postProcesses: List of all available post-preccesses.
    func update(postProcesses: [PostProcessing]) {
        self.postProcesses = postProcesses
    }

    /// Updates `FileStorage`.
    /// - Parameter fileStorage: a new `FileStorage`
    func update(with fileStorage: FileStorage) {
        self.fileStorage = fileStorage
    }

    /// Method used to start all operations in Queue.
    ///
    /// Please note, the dependent operation used for the purpose that a new operation could be added to the queue dynamically,
    /// taking into account that all operations in the queue can be completed before adding a new operation.
    /// - Parameter dependentOperation: The operation that Queue will be dependent on before it finishes all operations.
    func start(withDependentOperation dependentOperation: Operation?) {

        // no post processes
        guard postProcesses.count > 0 else { return }

        // suspend
        self.isSuspended = true

        // if there are no operations in the queue
        if self.operationCount == 0 {
            // add the start operation to the queue
            let postProcessingStartOperation = BlockOperation(block: { [weak self] in
                self?.onStarted?()
            })
            self.addOperation(postProcessingStartOperation)
        }

        // if the finishedOperation does not exist
        if finishedOperation == nil {
            // create the finishedOperation
            finishedOperation = BlockOperation(block: { [weak self] in
                self?.onComplete?(self?.failedTasks.synchronizedArray ?? [])
            })

            finishedOperation?.completionBlock = { [weak self] in
                self?.reset()
            }
        }

        // if there is a dependent operation
        if let dependentOperation = dependentOperation {
            // add conditions that the final operation depends on dependentOperation
            finishedOperation?.addDependency(dependentOperation)
        }

        // if finishedOperation not nil
        if let finishedOperation = self.finishedOperation,
            !isFinishedOperationAdded {
            // add finishedOperation to queue
            self.addOperation(finishedOperation)
            isFinishedOperationAdded = true
        }

        // if post process should start in concurrency to download queue
        if self.postProcessInConcurrencyToDownloadQueue {
            // start queue
            self.isSuspended = false
        }
    }

    /// Add post-process operation to queue.
    /// - Parameter fileData: `FileData` object that represents a file location `URL`, filename and file extension.
    public func addPostProcessOperation(withFileData fileData: DMSwiftTypealias.Download.SavedFileData?) -> Operation? {

        guard let location = fileData?.location,
            let fileName = fileData?.filename,
            let fileExtension = fileData?.fileExtension else { return  nil }

        return addPostProcessOperation(withFileLocation: location, filename: fileName, fileExtension: fileExtension)
    }

    /// Add post-process operation to queue.
    /// - Parameters:
    ///   - fileLocation:  file location `URL`.
    ///   - filename: Filename.
    ///   - fileExtension: File extension.
    private func addPostProcessOperation(withFileLocation fileLocation: URL, filename: String, fileExtension: String) -> Operation? {
        guard postProcesses.count > 0 else { return nil }

        // creates a group of operations, since it is possible that there can be several post operations on one file.
        let groupPostProcessingOperation = GroupPostProcessingOperation(fileStorage: self.fileStorage, postProcessings: self.postProcesses)

        // prepare to start group of operations
        groupPostProcessingOperation.prepareToStart(withSourceLocation: fileLocation, filename: filename, fileExtension: fileExtension)

        // when group of operations complete
        groupPostProcessingOperation.onComplete = { [weak self] uncompleted in
            if uncompleted.count > 0 {
                // append failed task
                self?.failedTasks.append((fileLocation: fileLocation, process: uncompleted))
                // increment failed unit count
                self?.postProcessProgress.failedUnitCount += 1
            } else {
                // increment successfully finished unit count
                self?.postProcessProgress.finishedUnitCount += 1
            }
            // update progress
            if let progress = self?.postProcessProgress {
                self?.onTaskProgressUpdate?(progress)
            }
        }

        // add finishedOperation dependency to group of operation
        self.finishedOperation?.addDependency(groupPostProcessingOperation)
        // add group of operation to queue
        self.addOperation(groupPostProcessingOperation)
        // update total post process total unit count
        self.postProcessProgress.totalUnitCount += 1
        // update progress
        self.onTaskProgressUpdate?(self.postProcessProgress)

        return groupPostProcessingOperation
    }

    /// Resets parameters to the original value.
    private func reset() {
        postProcessProgress.reset()
        finishedOperation = nil
        isFinishedOperationAdded = false
    }
}
