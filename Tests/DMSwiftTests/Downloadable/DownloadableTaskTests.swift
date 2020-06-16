//
//  DownloadableTaskTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/7/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class DownloadableTaskTests: XCTestCase {

    var mockDownloadableTask: MockDownloadableTask?

    let filelocation = URL(fileURLWithPath: "/path/file")
    let remoteLocation = URL(string: "\(Const.Domain.Default)file")

    let filepath = "file/located/path"
    let _name = "name"
    let filename = "filename"
    let fileExtension = "exe"
    let size: Int64 = 100

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockDownloadableTask = MockDownloadableTask()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockDownloadableTask = nil
    }


    static var allTests = [
        ("testCompletion", testCompletion),
        ("testCreateFilespecIfNeeded", testCreateFilespecIfNeeded),
        ("testRemovePreviouslyDownloadedFile", testRemovePreviouslyDownloadedFile),
        ("testSaveFile", testSaveFile),
        ("testUpdateProgress", testUpdateProgress)
    ]

    func testCompletion() {

        let error: Error? = nil

        let expectation = XCTestExpectation(description: "completion callback")

        let delegate = MockDownloadDelegate()

        mockDownloadableTask?.delegate = delegate

        var expectationFulfillCount = 0

        let completionHandler: ((DMSwiftTypealias.Download.FileData) -> Void)? = { [weak self] (data) in

            XCTAssertEqual(self?.filelocation, data.location)
            XCTAssertEqual(self?.remoteLocation, data.url)
            XCTAssertNil(data.error)

            expectation.fulfill()

            expectationFulfillCount += 1

            // make sure it fulfilled twice, delegate + callback
            if expectationFulfillCount == 2 {
                expectation.fulfill()
            }
        }

        delegate.completionHandler = completionHandler

        mockDownloadableTask?.completionHandler = completionHandler

        mockDownloadableTask?.complete(withFileLocation: filelocation, url: remoteLocation, error: error)

        wait(for: [expectation], timeout: 5)

        // tests session.finishTasksAndInvalidate method
        XCTAssertNil(mockDownloadableTask?.session)
    }

    func testCreateFilespecIfNeeded() throws {

        // setUp - start
        var configuration = DefaultFileStorageConfiguration()
        configuration.createFilespec = true

        let path = Const.Path.Test

        var fileStorage = FileStorage(path: path, configuration: configuration)

        mockDownloadableTask?.fileStorage = fileStorage

        let remoteUrl = URL(string: Const.Domain.Default)!
        // setUp - end

        mockDownloadableTask?.createFilespecIfNeeded(from: remoteUrl, path: filepath, name: _name, filename: filename, fileExtension: fileExtension, size: size)

        var filespec = try fileStorage.filespec(withFilename: remoteUrl.absoluteString.MD5)

        // configuration.createFilespec = true
        XCTAssertNotNil(filespec)

        try? fileStorage.removeDirectory()

        configuration.createFilespec = false
        fileStorage.configuration = configuration

        mockDownloadableTask?.fileStorage = fileStorage

        mockDownloadableTask?.createFilespecIfNeeded(from: remoteUrl, path: filepath, name: _name, filename: filename, fileExtension: fileExtension, size: size)

        filespec = try? fileStorage.filespec(withFilename: remoteUrl.absoluteString.MD5)

        // configuration.createFilespec = false
        XCTAssertNil(filespec)

        // tearDown
        try? fileStorage.removeDirectory()
    }

    func testFileSavedHandler() {

        let expectation = XCTestExpectation(description: "file saved callback")

        let delegate = MockDownloadDelegate()

        mockDownloadableTask?.delegate = delegate

        var expectationFulfillCount = 0

        let onFileDataChange: ((_ fileData: DMSwiftTypealias.Download.SavedFileData?) -> Void)? = { [weak self] filedata in

            XCTAssertEqual(self?.filelocation, filedata?.location)
            XCTAssertEqual(self?.filename, filedata?.filename)
            XCTAssertEqual(self?.fileExtension, filedata?.fileExtension)

            expectation.fulfill()

            expectationFulfillCount += 1

            // make sure it fulfilled twice, delegate + callback
            if expectationFulfillCount == 2 {
                expectation.fulfill()
            }
        }

        delegate.onFileDataChange = onFileDataChange
        mockDownloadableTask?.onFileDataChange = onFileDataChange

        mockDownloadableTask?.fileSaved(at: filelocation, from: remoteLocation, filename: filename, name: _name, fileExtension: fileExtension, size: size)

        wait(for: [expectation], timeout: 5)
    }

    func testRemovePreviouslyDownloadedFile() throws {

        // setUp - start
        let path = Const.Path.Test

        let fileStorage = FileStorage(path: path)

        let removeUrl = URL(string: "\(Const.Domain.Default)filename.exe")!

        let fileData = removeUrl.filenameAndExtention(useHashedPathForFilename: fileStorage.configuration.useHashedPathForFilename)

        let data = Data(count: 1)

        mockDownloadableTask?.fileStorage = fileStorage
        // setUp - end

        let fileLocation = fileStorage.createFile(from: data, filename: fileData.filename!, fileExtension: fileData.extension)

        // file saved successfully
        XCTAssertNotNil(fileLocation)
        XCTAssertNotNil(try fileStorage.searchFile(with: removeUrl))

        mockDownloadableTask?.removePreviouslyDownloaded(url: removeUrl)

        // file removed successfully
        XCTAssertNil(try? fileStorage.searchFile(with: removeUrl))

        // tearDown
        try? fileStorage.removeDirectory()

    }

    func testSaveFile() {

        // setUp - start
        let path = Const.Path.Test

        let fileStorage = FileStorage(path: path)

        mockDownloadableTask?.fileStorage = fileStorage

        let data = Data(count: 1)

        let removeUrl = URL(string: "\(Const.Domain.Default)filename.exe")!

        let fileData = removeUrl.filenameAndExtention(useHashedPathForFilename: fileStorage.configuration.useHashedPathForFilename)

        let fileUrl = fileStorage.urlFor(filename: fileData.filename!, fileExtension: fileData.extension)
        // setUp - end

        // file not exists yet
        XCTAssertFalse(fileStorage.fileManager.fileExists(atPath: fileUrl.path))

        mockDownloadableTask?.save(data: data, toLocation: fileUrl, withFilename: fileData.filename!, fileExtension: fileData.extension)

        // file created
        XCTAssertEqual(fileStorage.fileData(fileUrl)?.count, 1)

        mockDownloadableTask?.save(data: data, toLocation: fileUrl, withFilename: fileData.filename!, fileExtension: fileData.extension)

        // file updated
        XCTAssertEqual(fileStorage.fileData(fileUrl)?.count, 2)

        // tearDown
        try? fileStorage.removeDirectory()

    }

    func testUpdateProgress() {

        let bytesWritten: Int64 = 1
        let totalBytesWritten: Int64 = 2
        let totalBytesExpectedToWrite: Int64 = 3

        let percentageDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)

        let expectation = XCTestExpectation(description: "progress callback")

        let delegate = MockDownloadDelegate()

        mockDownloadableTask?.delegate = delegate

        var expectationFulfillCount = 0

        let onUpdateProgress: ((DMSwiftTypealias.Download.ProgressData) -> Void)? = { (data) in

            XCTAssertEqual(bytesWritten, data.receivedSize)
            XCTAssertEqual(totalBytesWritten, data.downloadedSize)
            XCTAssertEqual(totalBytesExpectedToWrite, data.fileSize)
            XCTAssertEqual(percentageDownloaded, data.progress)

            expectationFulfillCount += 1

            // make sure it fulfilled twice, delegate + callback
            if expectationFulfillCount == 2 {
                expectation.fulfill()
            }
        }

        delegate.onUpdateProgress = onUpdateProgress
        mockDownloadableTask?.onUpdateProgress = onUpdateProgress

        let isSuccess = mockDownloadableTask!.updateProgress(withBytesWritten: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)

        wait(for: [expectation], timeout: 5)

        // not succeed, because of progress less than 100%
        XCTAssertFalse(isSuccess)

    }

}
