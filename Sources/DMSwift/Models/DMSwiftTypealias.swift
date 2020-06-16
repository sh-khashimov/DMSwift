//
//  DMSwiftTypealias.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 4/28/20.
//  Copyright © 2020 DMSwift. All rights reserved.
//

import Foundation

/// Collection of typealias
public struct DMSwiftTypealias {

    /// Task count progress.
    ///
    /// Parameters:
    ///   - **progress**: Progress as a percentage.
    ///   - **finishedTaskCount**: Finished task count.
    ///   - **taskCount**: Total running task count.
    public typealias TaskCountProgress = (progress: Float, finishedTaskCount: Int64, taskCount: Int64)


    /// Total downloaded size progress.
    ///
    /// Parameters:
    ///   - **progress**: Progress as a percentage.
    ///   - **downloadedSize**: Total downloaded size.
    ///   - **totalSize**: Total files size.
    public typealias DownloadedSizeProgress = (progress: Float, downloadedSize: Int64, totalSize: Int64)
}

public extension DMSwiftTypealias {

    /// Group of typealias related to the Download
    struct Download {

        /// A failed task.
        ///
        /// Parameters:
        ///   - **url**: Url of a failed task.
        ///   - **error**: A fail error.
        public typealias FailedTask = (url: URL, error: Error?)

        /// A group of data related to the saved file.
        ///
        /// Parameters:
        ///   - **location**: The saved file location.
        ///   - **filename**: A filename of the file.
        ///   - **fileExtension**: A file extension.
        public typealias SavedFileData = (location: URL?, filename: String?, fileExtension: String?)

        /// A group of data related to the downloaded file.
        ///
        /// Parameters:
        ///   - **location**: The saved file location.
        ///   - **url**: A file location, from which started a download.
        ///   - **error**: An error, if unsuccessfully downloaded or saved.
        public typealias FileData = (location: URL?, url: URL?, error: Error?)

        /// A Download progress.
        ///
        /// Parameters:
        ///   - **progress**: Progress as a percentage.
        ///   - **downloadedSize**: Total downloaded size.
        ///   - **receivedSize**: A new received data size.
        ///   - **fileSize**: Total file size.
        public typealias ProgressData = (progress: Float, downloadedSize: Int64, receivedSize: Int64, fileSize: Int64)
    }
}

public extension DMSwiftTypealias {

    /// Group of typealias related to the FileStorage
    struct Storage {

        /// A group of data related to a file.
        ///
        /// Parameters:
        ///   - **name**: A name of the file.
        ///   - **filename**: A filename of the file.
        ///   - **extension**: A file extension.
        public typealias Filename = (name: String?, filename: String?, extension: String?)
    }
}

public extension DMSwiftTypealias {

    /// Group of typealias related to the PostProcess
    struct PostProcess {

        /// A failed task.
        ///
        /// Parameters:
        ///   - **fileLocation**: A failed file location.
        ///   - **process**: A list of process names and its errors.
        public typealias FailedTask = (fileLocation: URL, process: [(name: String, error: Error?)])
    }
}
