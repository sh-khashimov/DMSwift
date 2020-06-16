//
//  DownloadQueueTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/8/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class DownloadQueueTests: XCTestCase {

    let path = Const.Path.Temp

    var fileStorage: FileStorage!

    var configuration: DMSwiftConfiguration!
    
    var downloadQueue: DownloadQueue!

    var fileSize = 15

    var data: Data!

    var requests: [MockRequest] {
        var requests: [MockRequest] = []
        for index in 1...10 {
            let request = mockRequest(filename: "filename\(index)", fileExtension: "exe", error: nil)
            requests.append(request)
        }
        return requests
    }

    override func setUp() {
        data = Data(count: fileSize)

        fileStorage = FileStorage(path: path)

        configuration = DefaultDMSwiftConfiguration()
        configuration.urlSessionTaskType = .dataTask

        downloadQueue = DownloadQueue(configuration: configuration, fileStorage: fileStorage)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try? fileStorage.removeDirectory()
    }


    static var allTests = [
        ("testStart", testStart)
    ]

    func testStart() {

        let complitionExpectation = XCTestExpectation(description: "complition")

        let requests = self.requests
        let taskCount = requests.count

        var finishedExpectationCount = 0

        downloadQueue.start(requests) { (fileLocation, remoteUrl, error) in
            // we just test for closure callback
            finishedExpectationCount += 1
            if (taskCount == finishedExpectationCount) {
                complitionExpectation.fulfill()
            }
        }

        wait(for: [complitionExpectation], timeout: 5)
    }

    func mockRequest(filename: String, fileExtension: String, error: Error?) -> MockRequest {

        let url = URL(string: "\(Const.Domain.Default)\(filename).\(fileExtension)")!

        let interval: TimeInterval = 30

        let response = MockHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: nil, headerFields: nil, expectedContentLength: Int64(fileSize))

        let request = MockRequest(url: url, timeout: interval, data: data, iteration: 3, error: error, response: response)

        return request
    }
}
