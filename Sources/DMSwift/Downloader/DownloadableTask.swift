//
//  DownloadableTask.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// General logic responsible for downloading the file.
protocol DownloadableTask: class {

    var delegate: DownloadDelegate? { get set }

    /// The file size recieved.
    var onReciveFileSize: ((_ fileSize: Int64) -> Void)? { get set }

    /// Progress updated.
    var onUpdateProgress: ((_ progress: DMSwiftTypealias.Download.ProgressData) -> Void)? { get set }

    /// Download complete.
    var completionHandler: ((_ data: DMSwiftTypealias.Download.FileData) -> Void)? { get set }

    /// The file data saved.
    var onFileDataChange: ((_ fileData: DMSwiftTypealias.Download.SavedFileData) -> Void)? { get set }

    /// The file storage manager that used to save a file.
    var fileStorage: FileStorage? { get set }

    /// The file saved location, filename and file extension.
    var fileData: DMSwiftTypealias.Download.SavedFileData? { get set }

    var session: URLSessionTestable? { get set }

    /// Total received bytes. Used on URLSessionDataDelegate.
    var totalBytesWritten: Int64 { get set }

    /// File size.
    var fileSize: Int64 { get set }

    /// Download type.
    var downloadType: URLSessionTaskType { get set }

    /// Starts download task.
    func start()

    /// Cancel download task.
    func cancel()
}

extension DownloadableTask {

    /// Completes the task.
    /// - Parameters:
    ///   - location: File location.
    ///   - url: File remote location.
    ///   - error: Error.
    func complete(withFileLocation location: URL?, url: URL?, error: Error?) {
        let downloadedFileData: DMSwiftTypealias.Download.FileData = (location: location, url: url, error: error)
        self.completionHandler?(downloadedFileData)
        delegate?.completed(downloadedFileData)
        self.session?.finishTasksAndInvalidate()
    }

    /// Create a Filespec if needed.
    /// - Parameters:
    ///   - url: Remote file location.
    ///   - path: Path where file is located.
    ///   - name: Remove file name.
    ///   - filename: Filename.
    ///   - fileExtension: File extension.
    ///   - size: File size.
    func createFilespecIfNeeded(from url: URL?,  path: String?, name: String?, filename: String?, fileExtension: String?, size: Int64?) {
        if fileStorage?.configuration.createFilespec ?? false {
            let filespec: Filespec = Filespec(url: url, directoryPath: fileStorage?.path, name: name, filename: filename, fileExtension: fileExtension, size: size, searchPathDirectoryId: fileStorage?.configuration.searchPathDirectory.rawValue)
            _ = fileStorage?.createFilespec(filespec)
        }
    }

    /// The method used after successfully saving a file.
    ///
    ///  This method creates Filespec if needed and notify file data changes.
    /// - Parameters:
    ///   - location: File saved location.
    ///   - url: File remote location.
    ///   - filename: Filename.
    ///   - name: File remote name.
    ///   - fileExtension: File extension.
    ///   - size: File size.
    func fileSaved(at location: URL, from url: URL?, filename: String, name: String?, fileExtension: String?, size: Int64?) {
        // Creates Filespec if needed.
        createFilespecIfNeeded(from: url, path: location.path, name: name, filename: filename, fileExtension: fileExtension, size: size)

        // Updates file saved data.
        //TODO: check filename or name!
        self.fileData = (location: location, filename: filename, fileExtension: fileExtension)
        guard let fileSavedData = self.fileData else { return }
        onFileDataChange?(fileSavedData)
        self.delegate?.fileData(fileSavedData)
    }

    /// Removes previously a downloaded file.
    /// - Parameter url: Remote file location.
    func removePreviouslyDownloaded(url: URL?) {
        if let url = url {
            try? fileStorage?.removeFile(url)
        }
    }

    /// Saves the data to the given location with filename and file extension.
    ///
    /// If a file exists, a given data will be added to the end of the file.
    /// - Parameters:
    ///   - data: Data.
    ///   - fileLocation: A location where a file will be saved.
    ///   - filename: Filename.
    ///   - fileExtension: File extension.
    func save(data: Data, toLocation fileLocation: URL, withFilename filename: String, fileExtension: String?) {
        guard let fileStorage = self.fileStorage else { return }
        // If the file already exists on local storage.
        if fileStorage.fileManager.fileExists(atPath: fileLocation.path) {
            // Creates FileHandle for writing to the file.
            let fileHandle = try? FileHandle(forWritingTo: fileLocation)
            // Moves file pointer to the end.
            fileHandle?.seekToEndOfFile()
            // Writes received data to the file.
            fileHandle?.write(data)
            // Closes the file.
            fileHandle?.closeFile()
        } else {
            // The file not exists, creates new one.
            _ = fileStorage.createFile(from: data, filename: filename, fileExtension: fileExtension)
            //            try? data.write(to: fileUrl, options: .atomic)
        }
    }


    /// This method updates progress and returns true if download complete.
    /// - Parameters:
    ///   - bytesWritten: Bytes count that written.
    ///   - totalBytesWritten: Total bytes count that written.
    ///   - totalBytesExpectedToWrite: Total bytes expected to write.
    func updateProgress(withBytesWritten bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) -> Bool {
        // Updates total received bytes.
        self.totalBytesWritten = totalBytesWritten
        // Creates a downloaded percent.
        let percentageDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        // Updates progress.
        let downloadProgressData: DMSwiftTypealias.Download.ProgressData = (progress: percentageDownloaded, downloadedSize: totalBytesWritten, receivedSize: bytesWritten, fileSize: totalBytesExpectedToWrite)
        delegate?.updated(downloadProgressData)
        onUpdateProgress?(downloadProgressData)
        return percentageDownloaded >= 1
    }

    /// Check status code for success, and return success status as a boolean.
    ///
    /// If success was failed, completes with error `DownloadError.cannotLoadFromNetwork`
    /// - Parameters:
    ///   - response: Network response.
    ///   - url: Network url.
    func isStatusSuccess(response: URLResponse?, url: URL?) -> Bool {
        // if response is HTTP response
        if let httpResponse = response as? HTTPURLResponse {
            // check status code
            let status = httpResponse.statusWithSuccess
            if !status.isSuccess {
                let error = DownloadError.cannotLoadFromNetwork(statusCode: status.code)
                complete(withFileLocation: nil, url: url, error: error)
                // Logs error.
                Logger.shared.downloadError(error, from: url)
                return false
            }
        }
        // response is not HTTP, return success
        return true
    }
}

// - MARK: Download Type == .downloadTask
extension DownloadableTask where Self: URLSessionDownloadDelegate {

    /// After finishing downloading, saves the file to a given location.
    /// - Parameters:
    ///   - url: A file remote location.
    ///   - location: A location where a file will be saved.
    ///   - filenameAlias: Filename, name and file extension.
    func didFinishDownloading(from url: URL?, to location: URL, filenameAlias: DMSwiftTypealias.Storage.Filename?) {

        // Removes previously a downloaded file.
        if let url = url {
            try? fileStorage?.removeFile(url)
        }

        // Guard filename.
        guard let filename = filenameAlias?.filename else {
            // Completes with error.
            let error = DownloadError.invalidFilename(path: url?.path)
            complete(withFileLocation: nil, url: url, error: error)
            // Logs error.
            Logger.shared.downloadError(error, from: url)
            return
        }

        // The file should be moved at that method, otherwise, the file will be deleted from a temp directory.
        guard let fileLocation = try? fileStorage?.moveFile(at: location, withFileName: filename, fileExtension: filenameAlias?.extension)
            else {
                // Completes with error.
                let error = DownloadError.cannotMoveFile(path: location.path, filename: filename, fileExtension: filenameAlias?.extension)
                complete(withFileLocation: nil, url: url, error: error)
                // Logs error.
                Logger.shared.downloadError(error, from: url)
                return
        }

        fileSaved(at: fileLocation, from: url, filename: filenameAlias?.filename ?? filename, name: filenameAlias?.name, fileExtension: filenameAlias?.extension, size: totalBytesWritten)
        // Logging.
        Logger.shared.fileCachedAtPath(fileLocation.absoluteString, from: url)
        // Complete task.
        complete(withFileLocation: fileLocation, url: url, error: nil)
    }
}


// - MARK: Download Type == .dataTask
extension DownloadableTask where Self: URLSessionDataDelegate {

    /// Updates a file size.
    /// - Parameters:
    ///   - fileSize: A file size.
    ///   - url: A file remote location.
    ///   - filenameAlias: Filename, name and file extension.
    func didReceive(fileSize: Int64, at url: URL?, filenameAlias: DMSwiftTypealias.Storage.Filename?) {
        // Reset total received bytes.
        totalBytesWritten = 0
        // Updates file size.
        self.fileSize = fileSize
        // if the file size is undefined, there is no reason to download further,
        // since won't be determined download completion
        guard fileSize > 0 else {
            // cancel the task if the file size is undefined
            cancel()
            return
        }
        // Remove previously downloaded file
        if let filename = filenameAlias?.name {
            try? fileStorage?.removeFile(fileName: filename, fileExtension: filenameAlias?.extension)
            try? fileStorage?.removeFilespec(url)
        }
    }

    /// Should be used when new data was received.
    ///
    /// This method saves the data, updates progress.
    /// If progress returns true, it notifies the successfully saved file and completes the task.
    /// - Parameters:
    ///   - data: A new recevied data.
    ///   - url: A file remote location.
    ///   - filenameAlias: Filename, name and file extension.
    func didReceive(data: Data, at url: URL?, filenameAlias: DMSwiftTypealias.Storage.Filename?) {

        // Guard filename.
        guard let _filename = filenameAlias?.filename else {
            // Complete with error
            let error = DownloadError.invalidFilename(path: url?.path)
            complete(withFileLocation: nil, url: url, error: error)
            // Logs error.
            Logger.shared.downloadError(error, from: url)
            return
        }

        // Guard file's local location.
        guard let fileUrl = fileStorage?.urlFor(filename: _filename, fileExtension: filenameAlias?.extension) else {
            let error = DownloadError.fileLocalURLCannotBeCreated(filename: _filename, fileExtension: filenameAlias?.extension)
            // Complete with error
            complete(withFileLocation: nil, url: url, error: error)
            // Logs error.
            Logger.shared.downloadError(error, from: url)
            return
        }

        save(data: data, toLocation: fileUrl, withFilename: _filename, fileExtension: filenameAlias?.extension)

        let receivedSize = Int64(data.count)
        let totalBytesWritten = self.totalBytesWritten + Int64(data.count)

        // Whether the download is complete.
        let isComplete = updateProgress(withBytesWritten: receivedSize, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: fileSize)

        //If download complete.
        if isComplete {
            // Gets file local location.
            if let fileLocation = fileStorage?.urlFor(filename: filenameAlias?.filename ?? _filename, fileExtension: filenameAlias?.extension) {

                fileSaved(at: fileLocation, from: url, filename: _filename, name: filenameAlias?.name, fileExtension: filenameAlias?.extension, size: totalBytesWritten)
            }
            // Complete task.
            complete(withFileLocation: fileUrl, url: url, error: nil)
        }
    }
}

extension DownloadableTask where Self: URLSessionTaskDelegate {

    /// If the task completed with an error, then completes the task with an error.
    ///
    /// If `downloadType == .dataTask`, removes unfinished file from device storage.
    /// - Parameters:
    ///   - error: Error.
    ///   - url: File location.
    ///   - filenameAlias: Filename, name and file extension.
    func didCompleteWithError(error: Error?, at url: URL?, filenameAlias: DMSwiftTypealias.Storage.Filename?) {
        // Check only if completed with error.
        guard let error = error else { return }

        // If download type is equal to .dataTask
        if downloadType == .dataTask {
            // Removes an unfinished download file.
            if let filename = filenameAlias?.name,
                let fileUrl = fileStorage?.urlFor(filename: filename, fileExtension: filenameAlias?.extension) {
                try? fileStorage?.removeFile(fileUrl)
            }
        }
        // Complete task with error.
        complete(withFileLocation: nil, url: url, error: error)
    }
}
