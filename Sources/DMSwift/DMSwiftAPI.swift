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
    ///   - forceReload: Whether or not should force download, even if the file with the same name located in the device storage.
    ///   - completion: Completion handler called when one of the download operations is finish in the queue.
    func download(_ url: URL, forceReload: Bool = false, completion: ((_ fileLocation: URL?, _ fromUrl: URL?, _ error: Error?) -> Void)? = nil) {
        prepareDownload([url.urlRequest], forceReload: forceReload, completion: completion)
    }

    /// Adds a download tasks to the queue.
    /// - Parameters:
    ///   - urls: A list of remote locations of the files.
    ///   - forceReload: Whether or not should force download, even if the file with the same name located in the device storage.
    ///   - completion: Completion handler called when one of the download operations is finish in the queue.
    func download(_ urls: [URL], forceReload: Bool = false, completion: ((_ fileLocation: URL?, _ fromUrl: URL?, _ error: Error?) -> Void)? = nil) {
        let requests = urls.map({ $0.urlRequest })
        prepareDownload(requests, forceReload: forceReload, completion: completion)
    }

    /// Adds a download task to the queue.
    /// - Parameters:
    ///   - request: Request for remote file.
    ///   - forceReload: Whether or not should force download, even if the file with the same name located in the device storage.
    ///   - completion: Completion handler called when one of the download operations is finish in the queue.
    func download(_ request: URLRequest, forceReload: Bool = false, completion: ((_ fileLocation: URL?, _ fromUrl: URL?, _ error: Error?) -> Void)? = nil) {
        download([request], forceReload: forceReload, completion: completion)
    }

    /// Adds a download tasks to the queue.
    /// - Parameters:
    ///   - requests: Requests for remote files.
    ///   - forceReload: Whether or not should force download, even if the file with the same name located in the device storage.
    ///   - completion: Completion handler called when one of the download operations is finish in the queue.
    func download(_ requests: [URLRequest], forceReload: Bool = false, completion: ((_ fileLocation: URL?, _ fromUrl: URL?, _ error: Error?) -> Void)? = nil) {
        prepareDownload(requests, forceReload: forceReload, completion: completion)
    }

    /// <#Description#>
    /// - Parameter postProcesses: <#postProcesses description#>
    func update(postProcesses: [PostProcessing]) {
        self.postProcessQueue.update(postProcesses: postProcesses)
    }

    /// Cancels all tasks
    func cancel() {
        downloadQueue.cancelAllOperations()
        postProcessQueue.cancelAllOperations()
        // TODO: Cancel delegate?
    }

    /// Deletes files at the specified directory.
    func removeFilesFromDirectory() {
        try? fileStorage.removeFilesFromDirectory()
    }
}
