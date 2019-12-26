//
//  PostProcessing.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/14/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// The `PostProcessing` protocol is used to create post-processes that can be used after the file has been downloaded.
/// For example, unzip .zip files or create image thumbnails.
///
/// The implementation requirements for post-processing are as follows.
/// For the correct operation, the object that is inherited from `PostProcessing` must be *Value Types (struct)*.
/// Under the **supportedFileExtensions** parameter, specify a list of file extensions over which post-processing can be performed.
/// Use the **prepare** method to get the data you need to start post-processing.
/// Describe the logic behind post-processing in the **process** method.
/// Call **onComplete**, after the completion of post-processing.
public protocol PostProcessing {

    /// A set of file extensions over which post-processing will be performed.
    ///
    /// **Example**: *supportedFileExtensions = ["png", "jpg"]*
    var supportedFileExtensions: Set<String> { get }

    /// Used to report about the completion of post-processing.
    ///
    /// If the post-processing failed, then an `Error` object must be passed.
    var onComplete: ((_ withError: Error?) -> Void)? { get set }

    /// This method passes parameters that may be needed to start post-processing.
    ///
    /// Since all parameters are *Value Types*, you can store the needed parameters globally.
    /// - Parameters:
    ///   - fileStorage: Use this parameter if you need to save or delete a file.
    ///   - filename: Local filename.
    ///   - fileExtention: File extention.
    ///   - sourceLocation: The reference to the source file on which post-processing should be performed.
    mutating func prepare(fileStorage: FileStorage?,
                 filename: String?,
                 fileExtention: String?,
                 sourceLocation: URL?)

    /// The post-processing logic should be described in this method.
    ///
    /// The process method is used in `PostProcessingOperation` to start processing.
    func process()

    /// Will be called when operation is canceled.
    func cancel() -> Error?
}

public extension PostProcessing {
    /// A post process name, used for identification.
    ///
    /// Optional value.
    /// The default value is equal to the class name.
    var name: String {
        return "\(self)"
    }
}
