//
//  DMSwift.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 9/5/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// DMSwift provides a simple and efficient way to download files.
/// It can simultaneously download a large number of files,
/// monitors the progress of downloading,
/// concurrently post-process downloaded files,
/// supports logging, has a flexible configuration and easy to use API.
public class DMSwift {

    /// Download progress delegate.
    ///
    /// There is no reason to declare delegate as weak, as only *Value Types* are passed.
    /// also due to weak, delegates do not work when the `Downloader` class is declared locally.
    public weak var downloadProgressDelegate: DownloaderProgressDelegate?

    /// Post-process delegate
    ///
    /// There is no reason to declare delegate as weak, as only *Value Types* are passed.
    /// also due to weak, delegates do not work when the `Downloader` class is declared locally.
    public weak var postProcessDelegate: PostProcessDelegate?

    /// Informs when downloaded size or total files size changes.
    public var onDownloadUpdateSize: ((_ progress: DMSwiftTypealias.DownloadedSizeProgress) -> Void)?

    /// Informs on changes in download task count progress.
    public var onDownloadUpdateTaskCount: ((_ progress: DMSwiftTypealias.TaskCountProgress) -> Void)?

    /// Informs when download operations started.
    public var onDownloadStarted: (() -> Void)?

    /// Informs when all download operations finished.
    public var onDownloadComplete: (() -> Void)?

    /// Informs when downloaded operations finished and some of them have errors.
    public var onDownloadCompletedWithError: ((_ tasks: [DMSwiftTypealias.Download.FailedTask]) -> Void)?

    /// Informs when post-processing operations started.
    public var onPostProcessStarted: (() -> Void)?

    /// Informs when all post-processing operations finished.
    public var onPostProcessCompleted: (() -> Void)?

    /// Informs when post-processing operations finished and some of them have errors.
    public var onProcessCompletedWithError: ((_ tasks: [DMSwiftTypealias.PostProcess.FailedTask]) -> Void)?

    /// Informs on changes in post-process operations count progress.
    public var onPostProcessUpdateTaskCount: ((_ progress: DMSwiftTypealias.TaskCountProgress) -> Void)?

    /// Customizable configuration.
    public var configuration: DMSwiftConfiguration {
        didSet {
            downloadQueue.update(with: configuration)
            postProcessQueue.update(with: configuration)
        }
    }

    /// File storage manager.
    public var fileStorage: FileStorage {
        didSet {
            downloadQueue.update(with: fileStorage)
            postProcessQueue.update(with: fileStorage)
        }
    }

    /// Download queue.
    var downloadQueue: DownloadQueue

    /// Post-process queue.
    var postProcessQueue: PostProcessQueue

    /// Logging level.
    var logLevel: LogLevel {
        didSet {
            Logger.shared.logLevel = logLevel
        }
    }

    /// Initiates with default configuration.
    public init() {
        self.fileStorage = FileStorage()
        self.configuration = DefaultDMSwiftConfiguration()
        self.downloadQueue = DownloadQueue(configuration: configuration,
                                           fileStorage: fileStorage)
        self.postProcessQueue = PostProcessQueue(configuration: configuration,
                                                       fileStorage: fileStorage,
                                                       postProcessings: [])
        self.logLevel = .none
        Logger.shared.logLevel = logLevel

        downloadQueueBind()
        postProcessingQueueBind()
    }

    /// Initiates with required parameters.
    /// - Parameters:
    ///   - path: Specifies the path where files will be saved.
    ///   - postProcessings: List of post-processes for downloaded files.
    ///   - configuration: Configuration.
    ///   - fileStorageConfiguration: Configuration that used for `FileStorageManager`.
    ///   - logLevel: Logging level.
    public init(path: String? = nil,
                postProcessings: [PostProcessing] = [],
                configuration: DMSwiftConfiguration = DefaultDMSwiftConfiguration(),
                fileStorageConfiguration: FileStorageConfiguration = DefaultFileStorageConfiguration(),
                logLevel: LogLevel = .none) {
        let fileStorage = FileStorage(path: path, configuration: fileStorageConfiguration)
        self.fileStorage = fileStorage
        self.configuration = configuration
        self.downloadQueue = DownloadQueue(configuration: configuration,
                                           fileStorage: fileStorage)
        self.postProcessQueue = PostProcessQueue(configuration: configuration,
                                                       fileStorage: fileStorage,
                                                       postProcessings: postProcessings)
        self.logLevel = logLevel
        Logger.shared.logLevel = logLevel

        downloadQueueBind()
        postProcessingQueueBind()
    }

    /// Initiates with required parameters.
    /// - Parameter path: Specifies the path where files will be saved.
    public convenience init(path: String?) {
        self.init(path: path, postProcessings: [],
                  configuration: DefaultDMSwiftConfiguration(),
                  fileStorageConfiguration: DefaultFileStorageConfiguration(),
                  logLevel: .none)
    }

    /// Prepares files for download, removes duplicates from the provided list of requests.
    ///
    /// if the file is present locally, `forceDownload == true` or the request is already in the download queue, then it will not be added to download queue.
    /// - Parameter requests: Requests for remote files.
    /// - Parameter forceDownload: Whether to force download, even if the file with the same name located in the device storage.
    /// - Parameter completion: Completion handler called when one of the download operations is finish in the queue.
    func prepareDownload(_ requests: [URLRequestTestable], forceDownload: Bool = false, completion: ((_ fileData: DMSwiftTypealias.Download.FileData) -> Void)? = nil) {

        // removes duplicates from the provided list of requests.
        let taskRequests = requests.map({ URLRequestWrapper(request: $0) }).removingDuplicates().map({ $0.request })
//        let taskRequests = requests.removingDuplicates()

        // urls that needs to be downloaded.
        var urlRequestsNeedToDownload: [URLRequestTestable] = []

        for taskRequest in taskRequests {
            // already in progress
            guard let url = taskRequest.url,
                !downloadQueue.operations.contains(where: { $0.name == taskRequest.url?.absoluteString.MD5 })
                else { continue }

            // if the file is present locally,
            // forceReload == false,
            // return file local storage location.
            if !forceDownload,
                let fileUrl = try? fileStorage.searchFile(with: url) {
                // Logs cached file.
                Logger.shared.cachedFilePath(fileUrl.path)
                DispatchQueue.main.async {
                    completion?((fileUrl, url, nil))
                }
                continue
            }

            // adds not downloaded url.
            urlRequestsNeedToDownload.append(taskRequest)
        }

//        // if all files already downloaded.
//        if urlRequestsNeedToDownload.count == 0 {
//            // complete tasks.
//            downloadsCompleted(withFailledTasks: [])
//        } else {
//            // start downloads.
//            downloadQueue.start(urlRequestsNeedToDownload, completion: completion)
//            // start post-processes.
//            postProcessQueue.start(withDependentOperation: downloadQueue.finishedOperation)
//        }

        // start downloads.
        downloadQueue.start(urlRequestsNeedToDownload, completion: completion)
        // start post-processes.
        postProcessQueue.start(withDependentOperation: downloadQueue.finishedOperation)

    }

    /// Bind download queue events.
    private func downloadQueueBind() {
        downloadQueue.onStarted = { [weak self] in
                   self?.downloadStarted()
               }
        downloadQueue.onTaskProgressUpdate = { [weak self] progress in
            self?.downloadTaskUpdated(withProgress: progress)
        }
        downloadQueue.onDownloadProgressUpdate = { [weak self] progress in
                   self?.downloadFileUpdated(withProgress: progress)
               }
        downloadQueue.onFileSaveComplete = { [weak self] fileData in
            _ = self?.postProcessQueue.addPostProcessOperation(withFileData: fileData)
        }
        downloadQueue.onComplete = { [weak self] failedTasks in
            self?.downloadsCompleted(withFailledTasks: failedTasks)
        }
    }

    /// Bind post-processing queue events.
    private func postProcessingQueueBind() {
        postProcessQueue.onStarted = { [weak self] in
            self?.postProcessStarted()
        }
        postProcessQueue.onTaskProgressUpdate = { [weak self] progress in
            self?.postProcessUpdated(withProgress: progress)
        }
        postProcessQueue.onComplete = { [weak self] failedTasks in
            self?.postProcessCompleted(withFailedTasks: failedTasks)
        }
    }
    
}

// -MARK: Downloads related events
private extension DMSwift {

    /// Downloads start event handler.
    func downloadStarted() {
        DispatchQueue.main.async {
            self.onDownloadStarted?()
            self.downloadProgressDelegate?.downloadStarted()
        }
        // Logging.
        Logger.shared.downloadStarted()
    }

    /// Downloads progress update event handler.
    /// - Parameter progress: Downloads task progress.
    func downloadTaskUpdated(withProgress progress: DownloadTaskProgress) {
        DispatchQueue.main.async {
            self.onDownloadUpdateTaskCount?((progress.progress, progress.finishedUnitCount, progress.totalUnitCount))
            self.downloadProgressDelegate?.downloadDidUpdate( progress: progress.progress, finishedTaskCount: progress.finishedUnitCount, taskCount: progress.totalUnitCount)
        }
        // Logging.
        Logger.shared.downloadTaskUpdated(withProgress: progress)
    }

    /// Downloads files size progress update event handler.
    /// - Parameter progress: Downloads files size progress
    func downloadFileUpdated(withProgress progress: DownloadTaskProgress) {
        DispatchQueue.main.async {
            self.onDownloadUpdateSize?((progress.downloadProgress, progress.totalUnitRecievedSize, progress.totalUnitFileSize))
            self.downloadProgressDelegate?.downloadDidUpdate(progress: progress.downloadProgress, downloadedSize: progress.totalUnitRecievedSize, totalSize: progress.totalUnitFileSize)
        }
        // Logging.
        Logger.shared.downloadFileUpdated(withProgress: progress)
    }

    /// All downloads finish event handler.
    /// - Parameter failedTasks: Failed to complete tasks.
    func downloadsCompleted(withFailledTasks failedTasks: [(url: URL, error: Error?)]) {
        let isContainsErrors = failedTasks.count > 0
        if isContainsErrors {
            DispatchQueue.main.async {
                self.onDownloadCompletedWithError?(failedTasks)
                self.downloadProgressDelegate?.downloadDidCompletedWithError(tasks: failedTasks)
            }
            // Logging.
            Logger.shared.downloadsCompleted(withFailledTasks: failedTasks)
        } else {
            DispatchQueue.main.async {
                self.onDownloadComplete?()
                self.downloadProgressDelegate?.downloadDidComplete()
            }
            // Logging.
            Logger.shared.downloadCompleted()
        }

        //TODO: Should post process only if all files downloaded?
        if !postProcessQueue.postProcessInConcurrencyToDownloadQueue {
            self.postProcessQueue.isSuspended = false
        }
    }
}

// -MARK: Post-processes related events
private extension DMSwift {

    /// Post-processes start event handler.
    func postProcessStarted() {
        DispatchQueue.main.async {
            self.onPostProcessStarted?()
            self.postProcessDelegate?.postProcessStarted()
        }
        // Logging.
        Logger.shared.postProcessStarted()
    }

    /// Post-processes progress update event handler.
    /// - Parameter progress: Post-process task progress.
    private func postProcessUpdated(withProgress progress: TaskProgress) {
        DispatchQueue.main.async {
            self.postProcessDelegate?.postProcessDidUpdate(progress: progress.progress, finishedTaskCount: progress.finishedUnitCount, taskCount: progress.totalUnitCount)
            self.onPostProcessUpdateTaskCount?((progress.progress, progress.finishedUnitCount, progress.totalUnitCount))
        }
        // Logging.
        Logger.shared.postProcessUpdated(withProgress: progress)
    }

    /// All post-processes finish event handler.
    /// - Parameter failedTasks: Failed to complete tasks.
    private func postProcessCompleted(withFailedTasks failedTasks: [DMSwiftTypealias.PostProcess.FailedTask]) {
        let withError = failedTasks.count > 0
        DispatchQueue.main.async {
            if withError {
                self.onProcessCompletedWithError?(failedTasks)
                self.postProcessDelegate?.postProcessDidCompletedWithError(tasks: failedTasks)

                // Logging.
                Logger.shared.postProcessCompleted(withFailledTasks: failedTasks)

            } else {
                self.onPostProcessCompleted?()
                self.postProcessDelegate?.postProcessDidComplete()

                // Logging.
                Logger.shared.postProcessCompleted()
            }
        }
    }
}


extension DMSwift: DMSwiftAPI {}
