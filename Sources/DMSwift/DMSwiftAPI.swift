//
//  DMSwiftAPI.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/28/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

public protocol DMSwiftAPI where Self: DMSwift {}

// -MARK: Public API
public extension DMSwiftAPI {

    /// Adds a download task to the queue.
    /// - Parameters:
    ///   - url: A remote location of the file.
    ///   - forceDownload: Whether to force download, even if the file with the same name located in the device storage.
    ///   - completion: Completion handler called when one of the download operations is finish in the queue.
    func download(_ url: URL, forceDownload: Bool = false, completion: ((_ fileData: DMSwiftTypealias.Download.FileData) -> Void)? = nil) {
        prepareDownload([url.urlRequest], forceDownload: forceDownload, completion: completion)
    }

    /// Adds a download tasks to the queue.
    /// - Parameters:
    ///   - urls: A list of remote locations of the files.
    ///   - forceDownload: Whether to force download, even if the file with the same name located in the device storage.
    ///   - completion: Completion handler called when one of the download operations is finish in the queue.
    func download(_ urls: [URL], forceDownload: Bool = false, completion: ((_ fileData: DMSwiftTypealias.Download.FileData) -> Void)? = nil) {
        let requests = urls.map({ $0.urlRequest })
        prepareDownload(requests, forceDownload: forceDownload, completion: completion)
    }

    /// Adds a download task to the queue.
    /// - Parameters:
    ///   - request: Request for remote file.
    ///   - forceDownload: Whether to force download, even if the file with the same name located in the device storage.
    ///   - completion: Completion handler called when one of the download operations is finish in the queue.
    func download(_ request: URLRequest, forceDownload: Bool = false, completion: ((_ fileData: DMSwiftTypealias.Download.FileData) -> Void)? = nil) {
        download([request], forceDownload: forceDownload, completion: completion)
    }

    /// Adds a download tasks to the queue.
    /// - Parameters:
    ///   - requests: Requests for remote files.
    ///   - forceDownload: Whether to force download, even if the file with the same name located in the device storage.
    ///   - completion: Completion handler called when one of the download operations is finish in the queue.
    func download(_ requests: [URLRequest], forceDownload: Bool = false, completion: ((_ fileData: DMSwiftTypealias.Download.FileData) -> Void)? = nil) {
        prepareDownload(requests, forceDownload: forceDownload, completion: completion)
    }

    /// Updates **postProcesses**
    /// - Parameter postProcesses: List of all available post-preccesses.
    func update(postProcesses: [PostProcessing]) {
        self.postProcessQueue.update(postProcesses: postProcesses)
    }

    /// Cancels all tasks.
    func cancel() {
        downloadQueue.cancelAllOperations()
        postProcessQueue.cancelAllOperations()
        // TODO: Cancel delegate?
    }

    /// Cancels the download for a specific task.
    /// - Parameter url: A started download url.
    func cancel(_ url: URL) {
        guard let operation = downloadQueue.operations.first(where: {$0.name == url.absoluteString.MD5}) else { return }
        operation.cancel()
    }

    /// Deletes files at the specified directory.
    func removeFilesFromDirectory() {
        try? fileStorage.removeFilesFromDirectory()
    }
}
