//
//  DMSwiftTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/10/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class DMSwiftTests: XCTestCase {

    let downloadPorgressDelegate = MockDownloaderProgressDelegate()
    let postProcessDelegate = MockPostProcessDelegate()

    var downloadManager: DMSwift!

    var path = Const.Path.Temp

    var fileStorageConfiguration: FileStorageConfiguration!
    var configuration: DMSwiftConfiguration!

    let logLevel: LogLevel = .none

    var postProcesses: [PostProcessing] {
        var postProcesses: [PostProcessing] = []

        let postProcess1 = MockPostProcess(supportedFileExtensions: ["exe"])
        postProcesses.append(postProcess1)

        let postProcess2 = MockPostProcess(supportedFileExtensions: ["jpg"])
        postProcesses.append(postProcess2)

        return postProcesses
    }

    var requests: [MockRequest] {
        var requests: [MockRequest] = []
        for index in 1...10 {
            let request = mockRequest(filename: "filename\(index)", fileExtension: "exe", error: nil)
            requests.append(request)
        }
        return requests
    }

    let fileSize: Int64 = 15

    var data: Data!

    override func setUp() {

        data = Data(count: Int(fileSize))

        fileStorageConfiguration = DefaultFileStorageConfiguration()
        configuration = DefaultDMSwiftConfiguration()

        downloadManager = DMSwift(path: path, postProcessings: postProcesses, configuration: configuration, fileStorageConfiguration: fileStorageConfiguration, logLevel: logLevel)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        downloadManager.removeFilesFromDirectory()
    }


    static var allTests = [
        ("testDownload", testDownload)
    ]


    func testDownload() {

        let complitionExpectation = expectation(description: "complete")

        let url = URL(string: "\(Const.Domain.Default)filename.exe")!

        let timeout: TimeInterval = 30

        let mockResponse = MockHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: nil, headerFields: nil, expectedContentLength: fileSize)

        let mockRequest = MockRequest(url: url, timeout: timeout, data: data, iteration: 3, error: nil, response: mockResponse)

        let _fileLocation = downloadManager.fileStorage.urlFor(url)

        downloadManager.prepareDownload([mockRequest], forceDownload: true) { (fileLocation, remoteLocation, error) in

            XCTAssertEqual(_fileLocation, fileLocation)
            XCTAssertEqual(url, remoteLocation)
            XCTAssertNil(error)

            complitionExpectation.fulfill()
        }

        wait(for: [complitionExpectation], timeout: 50000000)
    }

    func mockRequest(filename: String, fileExtension: String, error: Error?) -> MockRequest {

        let url = URL(string: "\(Const.Domain.Default)\(filename).\(fileExtension)")!

        let interval: TimeInterval = 30

        let response = MockHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: nil, headerFields: nil, expectedContentLength: Int64(fileSize))

        let request = MockRequest(url: url, timeout: interval, data: data, iteration: 3, error: error, response: response)

        return request
    }


}
