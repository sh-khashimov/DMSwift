//
//  ImageProcessingOperation.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/7/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// Group of post-process operations.
///
/// Runs several post-processings on one file in its queue (not in parallel).
class GroupPostProcessingOperation: DefaultOperation {

    lazy private var internalQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    private var fileStorage: FileStorage?

    private let postProcessings: [PostProcessing]

    public var onComplete: ((_ processesNotCompleted: [(name: String, error: Error?)]) -> Void)?

    private var uncompletedProcesses = SynchronizedArray<(name: String, error: Error?)>()

    /// Initiates with required parameters.
    /// - Parameters:
    ///   - fileStorage: The file storage manager that used to pass to a `PostProcessing` object.
    ///   - postProcessings: Available post-processes.
    init(fileStorage: FileStorage?, postProcessings: [PostProcessing]) {
        self.fileStorage = fileStorage
        self.postProcessings = postProcessings

        super.init()

        internalQueue.isSuspended = true

        let startOperation = BlockOperation(block: { [weak self] in
            self?.state = .executing
        })

        internalQueue.addOperation(startOperation)
    }

    override func start() {
        if(self.isCancelled) {
            self.cancel()
            return
        }
        internalQueue.isSuspended = false
    }

    override func cancel() {
        // cancel the downloading
        self.internalQueue.cancelAllOperations()
        self.onComplete?(self.uncompletedProcesses.synchronizedArray)
        state = .finished
    }

    /// Prepare to start post-processing operations over a given source file.
    /// - Parameters:
    ///   - sourceLocation: The reference to the source file on which post-processing should be performed.
    ///   - filename: Local filename.
    ///   - fileExtension: File extention.
    func prepareToStart(withSourceLocation sourceLocation: URL, filename: String, fileExtension: String) {

        // Just in case, clears the list of uncompleted processes.
        self.uncompletedProcesses.clear()

        for postProcessing in postProcessings {
            // current post-process should supports given file extension
            guard postProcessing.supportedFileExtensions.contains(fileExtension) else { continue }
            // create a post-porcessing operation
            let postProcessingOperation = PostProcessingOperation(fileStorage: fileStorage, postProcessing: postProcessing)
            // prepare post-processing operation
            postProcessingOperation.prepareToStart(withSourceLocation: sourceLocation, filename: filename, fileExtension: fileExtension)
            // on post-process complete
            postProcessingOperation.onComplete = { [weak self] error in
                if let error = error {
                    self?.uncompletedProcesses.append((name: postProcessing.name, error: error))
                }
            }
            // add operation to queue
            internalQueue.addOperation(postProcessingOperation)
        }

        // create finishOperation
        let finishOperation = BlockOperation(block: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.onComplete?(strongSelf.uncompletedProcesses.synchronizedArray)
            strongSelf.state = .finished
        })

        // add finishOperation to queue
        internalQueue.addOperation(finishOperation)
    }
}
