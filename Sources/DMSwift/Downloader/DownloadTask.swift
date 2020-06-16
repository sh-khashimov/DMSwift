//
//  DownloadTask.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 11/18/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

class DownloadTask: NSObject, DownloadableTask {


    weak var delegate: DownloadDelegate?

    var onReciveFileSize: ((Int64) -> Void)?

    var onUpdateProgress: ((DMSwiftTypealias.Download.ProgressData) -> Void)?

    var completionHandler: ((DMSwiftTypealias.Download.FileData) -> Void)?

    /// The file data saved.
    var onFileDataChange: ((DMSwiftTypealias.Download.SavedFileData) -> Void)?

    var fileStorage: FileStorage?

    var fileData: DMSwiftTypealias.Download.SavedFileData?

    var session: URLSessionTestable?

    var totalBytesWritten: Int64 = 0

    private var task: URLSessionTaskTestable?

    /// Download type.
    var downloadType: URLSessionTaskType

    /// File size.
    var fileSize: Int64 = 0 {
        didSet {
            delegate?.received(fileSize: fileSize)
            onReciveFileSize?(fileSize)
        }
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
         _ completionHandler: ((DMSwiftTypealias.Download.FileData) -> Void)? = nil) {

        self.delegate = delegate
        self.fileStorage = fileStorage
        self.downloadType = downloadType

        self.completionHandler = completionHandler

        super.init()

        session = request.session(withTimeout: timeoutIntervalForRequest, delegate: self)

        switch downloadType {
        case .dataTask:
            task = session?.dataTask(with: request)
        case .downloadTask:
            task = session?.downloadTask(with: request)
        }
    }


    /// Starts download task.
    func start() {
        task?.resume()
    }

    /// Cancel download task.
    func cancel() {
        task?.cancel()
        session?.finishTasksAndInvalidate()
    }
}

// - MARK: Download Type == .downloadTask
extension DownloadTask: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let url = downloadTask.originalRequest?.url

        // Creates file name related data.
        let filenameAlias = downloadTask.response?.filenameAlias(useHashedPathForFilename:
            fileStorage?.configuration.useHashedPathForFilename ?? true, requestUrl: url)

        guard isStatusSuccess(response: downloadTask.response, url: url) else { return }

        didFinishDownloading(from: url, to: location, filenameAlias: filenameAlias)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        _ = updateProgress(withBytesWritten: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: downloadTask.response?.contentLength ?? downloadTask.response?.expectedContentLength ?? totalBytesExpectedToWrite)
    }

}

// - MARK: Download Type == .dataTask
extension DownloadTask: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

        // Creates file name related data.
        let filenameAlias = dataTask.response?.filenameAlias(useHashedPathForFilename:
            fileStorage?.configuration.useHashedPathForFilename ?? true, requestUrl: dataTask.originalRequest?.url)

        didReceive(fileSize: dataTask.fileSize, at: response.url, filenameAlias: filenameAlias)
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let url = dataTask.originalRequest?.url

        // Creates file name related data.
        let filenameAlias = dataTask.response?.filenameAlias(useHashedPathForFilename:
            fileStorage?.configuration.useHashedPathForFilename ?? true, requestUrl: url)

        guard isStatusSuccess(response: dataTask.response, url: url) else { return }

        didReceive(data: data, at: url, filenameAlias: filenameAlias)
    }
}

extension DownloadTask: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let url = task.originalRequest?.url

        // Creates file name related data.
        let filenameAlias = task.response?.filenameAlias(useHashedPathForFilename:
            fileStorage?.configuration.useHashedPathForFilename ?? true, requestUrl: url)

        didCompleteWithError(error: error, at: url, filenameAlias: filenameAlias)
    }
}
