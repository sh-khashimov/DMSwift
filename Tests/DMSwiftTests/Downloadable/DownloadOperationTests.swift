//
//  DownloadOperationTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/8/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class DownloadOpeartionTests: XCTestCase {

    let url = URL(string: "\(Const.Domain.Default)filename.exe")!

    let fileStorage = FileStorage(path: Const.Path.Temp)

    let timeout: TimeInterval = 30

    let downloadType: URLSessionTaskType = .dataTask

    let fileSize: Int64 = 15

    var data: Data!

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
        ("testDownloadOperation", testDownloadOperation),
        ("testDownloadOperationCancellation", testDownloadOperationCancellation)
    ]

    func testDownloadOperation() {

        let complitionExpectation = XCTestExpectation(description: "complition")

        let fileSizeExpectation = XCTestExpectation(description: "file size")

        let progressExpectation = XCTestExpectation(description: "progress")

        let fileSaveExpectation = XCTestExpectation(description: "file saved")

        let _fileLocation = fileStorage.urlFor(url)

        let downloadOperation = DownloadOperation(mockRequest, fileStorage: fileStorage, delegate: nil, downloadType: downloadType, timeoutIntervalForRequest: timeout) { [weak self] (fileLocation, remoteUrl, error) in

                XCTAssertEqual(_fileLocation, fileLocation)
                XCTAssertEqual(self?.url, remoteUrl)
                XCTAssertNil(error)

                complitionExpectation.fulfill()
        }

        downloadOperation.onReceiveFileSize = { fileSize in
            // doesn't need to test fileSize value, since it tests in DownloadTaskTests.
            // We only need test a closure
            fileSizeExpectation.fulfill()
        }

        downloadOperation.onUpdateProgress = { (progress) in
            // doesn't need to test fileSize value, since it tests in DownloadTaskTests.
            // We only need test a closure
            progressExpectation.fulfill()
        }

        downloadOperation.onFileDataChange = { fileData in
            // doesn't need to test fileSize value, since it tests in DownloadTaskTests.
            // We only need test a closure
            fileSaveExpectation.fulfill()
        }

        downloadOperation.start()

        wait(for: [complitionExpectation, fileSizeExpectation, progressExpectation, fileSaveExpectation], timeout: 5)
    }

    func testDownloadOperationCancellation() {

        let expectation = XCTestExpectation(description: "complition")

        let downloadOperation = DownloadOperation(mockRequest, fileStorage: fileStorage, delegate: nil, downloadType: downloadType, timeoutIntervalForRequest: timeout) { (fileLocation, remoteUrl, error) in

                XCTAssertNotNil(error)

                expectation.fulfill()
        }

        downloadOperation.cancel()

        wait(for: [expectation], timeout: 5)
    }
}
