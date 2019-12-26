//
//  PostProcessingOperation.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/25/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// Post-processing operation.
public class PostProcessingOperation: DefaultOperation {

    private var fileStorage: FileStorage?
    private var postProcessing: PostProcessing

    public var onComplete: ((_ error: Error?) -> Void)?

    /// Initiates with required parameters.
    /// - Parameters:
    ///   - fileStorage: The file storage manager that used to pass to a `PostProcessing` object.
    ///   - postProcessing: The post-process.
    public init(fileStorage: FileStorage?, postProcessing: PostProcessing) {
        self.fileStorage = fileStorage
        self.postProcessing = postProcessing

        super.init()

        self.postProcessing.onComplete = { [weak self] error in
            self?.onComplete?(error)
            self?.state = .finished
        }
    }

    /// Prepare to start post-process.
    /// - Parameters:
    ///   - sourceLocation: The reference to the source file on which post-processing should be performed.
    ///   - filename: Local filename.
    ///   - fileExtension: File extention.
    public func prepareToStart(withSourceLocation sourceLocation: URL, filename: String, fileExtension: String) {
        postProcessing.prepare(fileStorage: fileStorage, filename: filename, fileExtention: fileExtension, sourceLocation: sourceLocation)
    }

    override public func start() {
        if(self.isCancelled) {
            self.cancel()
            return
        }

        state = .executing

        postProcessing.process()
    }

    override public func cancel() {
        // cancel the downloading
        let error = postProcessing.cancel()
        onComplete?(error)
        state = .finished
    }
}
