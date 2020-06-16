//
//  DownloadTaskTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/8/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class DownloadTaskTests: XCTestCase {

    let fileStorage = FileStorage()

    let url = URL(string: "\(Const.Domain.Default)filename.exe")!

    let timeout: TimeInterval = 30

    let fileSize: Int64 = 15

    var data: Data!

    let delegate = MockDownloadDelegate()

    var mockResponse: MockHTTPURLResponse!

    var mockRequest: MockRequest!

    override func setUp() {

        data = Data(count: Int(fileSize))

        mockResponse = MockHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: nil, headerFields: nil, expectedContentLength: fileSize)

        mockRequest = MockRequest(url: url, timeout: timeout, data: data, iteration: 3, error: nil, response: mockResponse)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        try? fileStorage.removeDirectory()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    static var allTests = [
        ("testDataTask", testDataTask),
        ("testDownloadTask", testDownloadTask),
        ("testDataTaskCancel", testDataTaskCancel)
    ]

    func testDataTask() {

        let fileSizeExpectation = XCTestExpectation(description: "file size callback")
        let progressExpectation = XCTestExpectation(description: "progress callback")
        let fileExpectation = XCTestExpectation(description: "file saved callback")
        let completionExpectation = XCTestExpectation(description: "completion callback")

        let downloadDataTask = DownloadTask(mockRequest, fileStorage: fileStorage, delegate: delegate, downloadType: .dataTask, timeoutIntervalForRequest: 30, nil)

        downloadDataTask.completionHandler = { [weak self ](data) in

            XCTAssertNil(data.error)
            XCTAssertEqual(data.url, self?.mockRequest.url)

            completionExpectation.fulfill()
        }

        downloadDataTask.onUpdateProgress = { (progress) in
            
            if (progress.progress == 1) {
                progressExpectation.fulfill()
            }
        }

        downloadDataTask.onFileDataChange = { [weak self] fileData in

            let _fileData = self?.url.filenameAndExtention(useHashedPathForFilename: self?.fileStorage.configuration.useHashedPathForFilename ?? false)

            XCTAssertEqual(fileData.filename, _fileData?.filename)

            fileExpectation.fulfill()
        }

        var fileSizeexpectationFulfillCount = 0

        let onReciveFileSize: ((Int64) -> Void)? = { [weak self] size in

            XCTAssertEqual(self?.fileSize, size)

            fileSizeexpectationFulfillCount += 1

            // make sure it fulfilled twice, delegate + callback
            if fileSizeexpectationFulfillCount == 2 {
                fileSizeExpectation.fulfill()
            }
        }

        delegate.onReciveFileSize = onReciveFileSize

        downloadDataTask.onReciveFileSize = onReciveFileSize

        downloadDataTask.start()

        wait(for: [fileSizeExpectation, progressExpectation, fileExpectation, completionExpectation], timeout: 5)
    }

    func testDownloadTask() {

        let progressExpectation = XCTestExpectation(description: "progress callback")
        let fileExpectation = XCTestExpectation(description: "file saved callback")
        let completionExpectation = XCTestExpectation(description: "completion callback")

        let downloadTask = DownloadTask(mockRequest, fileStorage: fileStorage, delegate: delegate, downloadType: .downloadTask, timeoutIntervalForRequest: 30, nil)

        downloadTask.completionHandler = { [weak self ](data) in

            XCTAssertNil(data.error)
            XCTAssertEqual(data.url, self?.mockRequest.url)

            completionExpectation.fulfill()
        }

        downloadTask.onUpdateProgress = { (progress) in

            if (progress.progress == 1) {
                progressExpectation.fulfill()
            }
        }

        downloadTask.onFileDataChange = { [weak self] fileData in

            let _fileData = self?.url.filenameAndExtention(useHashedPathForFilename: self?.fileStorage.configuration.useHashedPathForFilename ?? false)

            XCTAssertEqual(fileData.filename, _fileData?.filename)

            fileExpectation.fulfill()
        }

        downloadTask.start()

        wait(for: [progressExpectation, fileExpectation, completionExpectation], timeout: 5)
    }

    func testDataTaskCancel() {

        let completionExpectation = XCTestExpectation(description: "completion callback")

        let downloadTask = DownloadTask(mockRequest, fileStorage: fileStorage, delegate: delegate, downloadType: .dataTask, timeoutIntervalForRequest: 30, nil)

        downloadTask.completionHandler = { (data) in

            XCTAssertNotNil(data.error)

            completionExpectation.fulfill()
        }

        downloadTask.cancel()

        wait(for: [completionExpectation], timeout: 5)
    }
}
