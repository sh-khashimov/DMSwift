//
//  MockSessionDownloadTask.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 11/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

protocol URLSessionDownloadTaskTestable {
    var onDidFinishDownload: ((_ url: URL?, _ location: URL) -> Void)? { get set }
    var onDidWriteData: ((_ bytesWritten: Int64, _ totalBytesWritten: Int64, _ totalBytesExpectedToWrite: Int64) -> Void)? { get set }
}

class MockSessionDownloadTask: URLSessionDownloadTask,  URLSessionDownloadTaskTestable {

    var mockRequest: MockRequest?

    private var _response: URLResponse?

    private let session = URLSession(configuration: URLSessionConfiguration.default)

    override var response: URLResponse? {
        return _response
    }

    override var originalRequest: URLRequest? {
        return URLRequest(url: mockRequest!.url!)
    }

    init(mockRequest: MockRequest?) {
        self.mockRequest = mockRequest
        self._response = mockRequest?.response
    }

    var onDidFinishDownload: ((_ url: URL?, _ location: URL) -> Void)?
    var onDidWriteData: ((_ bytesWritten: Int64, _ totalBytesWritten: Int64, _ totalBytesExpectedToWrite: Int64) -> Void)?

    override func resume() {
        super.resume()

        let delegate = mockRequest?.session?.delegate as? URLSessionDownloadDelegate

        let iteration = mockRequest?.iteration ?? 0
        let fileSize: Int64 = Int64(mockRequest?.data?.count ?? 0)
        let chunkSize: Int64 = fileSize / Int64(iteration)

        for index in 1...iteration {
            delegate?.urlSession?(session, downloadTask: self as URLSessionDownloadTask, didWriteData: chunkSize, totalBytesWritten: chunkSize*Int64(index), totalBytesExpectedToWrite: fileSize)
        }

        // Saves File
        let fileStorage = FileStorage(path: Const.Path.TempForDownloadTask)
        let fileData = mockRequest?.url?.filenameAndExtention(useHashedPathForFilename: fileStorage.configuration.useHashedPathForFilename)
        let fileLocation = fileStorage.urlFor(self.response!.url!)!
        let isSuccess = fileStorage.createFile(from: mockRequest!.data!, filename: fileData!.filename!, fileExtension: fileData?.extension)
//        try? mockRequest?.data?.write(to: fileLocation)

        XCTAssertTrue(isSuccess)

        delegate?.urlSession(session, downloadTask: self as URLSessionDownloadTask, didFinishDownloadingTo: fileLocation)

        try? fileStorage.removeDirectory()
    }

    override func cancel() {
        let delegate = mockRequest?.session?.delegate as? URLSessionTaskDelegate

        let error = NSError(domain: "cancelled", code: 100, userInfo: nil)
        delegate?.urlSession?(session, task: self as URLSessionTask, didCompleteWithError: error)
    }
}
