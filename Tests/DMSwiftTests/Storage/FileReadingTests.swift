//
//  FileReadingTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 11/13/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift


fileprivate struct TestableFileStorage: FileStorageManageable, FileReading {
    var configuration: FileStorageConfiguration
    var path: String?
    var fileManager: FileManager = FileManager()
}

class FileReadingTests: XCTestCase {

    fileprivate var directoryPath = Const.Path.Test
    fileprivate var configuration = DefaultFileStorageConfiguration()
    fileprivate var testableFileStorage: TestableFileStorage!
    fileprivate let fileManager = FileManager()

    fileprivate var domain = Const.Domain.Default
    fileprivate let filename = "1"
    fileprivate let fileExtension = "tmp"
    fileprivate let filespecExtention = "json"
    fileprivate var fileURL: URL!
    fileprivate var fullFileURL: URL!
    fileprivate var urlWithFilename: URL!
    fileprivate var urlWithoutFilename: URL!
    fileprivate var urlWithIncorrectFilename: URL!
    fileprivate var urlWithFilenameAndExtension: URL!
    fileprivate let filesize = 1
    fileprivate var data: Data!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testableFileStorage = TestableFileStorage(configuration: configuration, path: directoryPath)
        let fileManager = FileManager()
        try? fileManager.createDirectoryIfNeeded(testableFileStorage.directoryURL)

        data = Data(count: filesize)

        fileURL = testableFileStorage.directoryURL.appendingPathComponent(filename)
        fullFileURL = fileURL.appendingPathExtension(fileExtension)

        urlWithoutFilename = URL(string: domain)!
        urlWithFilename = URL(string: "\(domain)\(filename)")!
        urlWithFilenameAndExtension = URL(string: "\(domain)\(filename).\(fileExtension)")!
        urlWithIncorrectFilename = URL(string: "\(domain)assss\(filename).\(fileExtension)")!
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let fileManager = FileManager()
        try? fileManager.removeItem(at: testableFileStorage.directoryURL)
    }


    static var allTests = [
        ("testSearchFile", testSearchFile),
        ("testFileData", testFileData),
        ("testFilespec", testFilespec),
        ("testDirectoriesAndDirectoriesName", testDirectoriesAndDirectoriesName),
        ("testFilesIn", testFilesIn)
    ]

    func testSearchFile() throws {

        // populates a file
        try data.write(to: fileURL)
        try data.write(to: fullFileURL)

        // test search for incorrect file remote location
        XCTAssertThrowsError(try testableFileStorage.searchFile(with: urlWithoutFilename))
        // test search for incorrect file remote location
        XCTAssertThrowsError(try testableFileStorage.searchFile(with: urlWithIncorrectFilename))
        // test search for incorrect directory
        XCTAssertThrowsError(try testableFileStorage.searchFile(with: urlWithFilename, atDirectory: urlWithFilename))

        // try to find a file
        XCTAssertNoThrow(try testableFileStorage.searchFile(with: urlWithFilenameAndExtension))
        // try to find a file
        XCTAssertNoThrow(try testableFileStorage.searchFile(with: urlWithFilename))

        // try to find a file with filename
        XCTAssertNoThrow(try testableFileStorage.searchFile(withFilename: filename))

        // try to find a file with filename and file extension
        XCTAssertNoThrow(try testableFileStorage.searchFile(withFilename: filename, fileExtention: fileExtension))

        // try to find a file with filename and wrong file extension
        XCTAssertThrowsError(try testableFileStorage.searchFile(withFilename: filename, fileExtention: "mac"))


    }

    func testFileData() throws {

        // populates a file
        try data.write(to: fileURL)
        try data.write(to: fullFileURL)

        // test get file data for incorrect file remote location
        XCTAssertThrowsError(try testableFileStorage.fileData(at: urlWithoutFilename))
        // test get file data for incorrect file name at remote file location
        XCTAssertThrowsError(try testableFileStorage.fileData(at: urlWithIncorrectFilename))
        // test get file data for correct remote file location
        XCTAssertNotNil(try? testableFileStorage.fileData(at: urlWithFilename))
        // test get file data for correct remote file location
        XCTAssertNotNil(try? testableFileStorage.fileData(at: urlWithFilenameAndExtension))
    }

    func testFilespec() throws {

        let filespecURL = testableFileStorage.directoryURL.appendingPathComponent(".\(urlWithFilename.absoluteString.MD5)").appendingPathExtension(filespecExtention)

        // tests filespec for nil, if data is not correct JSON file.
        try data.write(to: filespecURL)
        let fileSpecJsonData = fileManager.contents(atPath: filespecURL.path)!
        XCTAssertNil(Filespec(fromJsonData: fileSpecJsonData))

        let filespec = Filespec(url: URL(string: domain), path: fullFileURL.path, name: filename, filename: filename, fileExtension: fileExtension, size: Int64(filesize), searchPathDirectoryId: nil)

        try filespec.jsonData?.write(to: filespecURL)

        // tests if filespec saved correctly
        var createdFilespec = try testableFileStorage.filespec(at: urlWithFilename)
        XCTAssertNotNil(createdFilespec)
        XCTAssertEqual(filespec, createdFilespec)

        // tests if filespec saved correctly
        createdFilespec = try testableFileStorage.filespec(withFilename: urlWithFilename.absoluteString.MD5)
        XCTAssertNotNil(createdFilespec)
        XCTAssertEqual(filespec, createdFilespec)


        // test get filespec with incorrect file remote location
        XCTAssertThrowsError(try testableFileStorage.filespec(at: urlWithoutFilename))
        // test get filespec with incorrect file remote location
        XCTAssertThrowsError(try testableFileStorage.filespec(at: urlWithoutFilename))
        // test search for incorrect directory
        XCTAssertThrowsError(try testableFileStorage.filespec(at: urlWithoutFilename, atDirectory: urlWithoutFilename))
        // test search for incorrect directory and filename
        XCTAssertThrowsError(try testableFileStorage.filespec(withFilename: "urlWithoutFilename", atDirectory: urlWithoutFilename))
    }

    func testDirectoriesAndDirectoriesName() throws {
        let newDirectoryName = "new"
        let newDirectoryURL = testableFileStorage.directoryURL.appendingPathComponent(newDirectoryName)
        try fileManager.createDirectoryIfNeeded(newDirectoryURL)
        let secondNewDirectoryName = "new2"
        let secondNewDirectoryURL = testableFileStorage.directoryURL.appendingPathComponent(secondNewDirectoryName)
        try fileManager.createDirectoryIfNeeded(secondNewDirectoryURL)

        let directories = try testableFileStorage.directories()

        // test directories
        XCTAssertEqual(directories.count, 2)

        // test directoriesName
        let directoriesName = testableFileStorage.directoriesName()
        XCTAssertEqual(directoriesName.count, 2)
        XCTAssertTrue(directoriesName.contains(newDirectoryName))
        XCTAssertTrue(directoriesName.contains(secondNewDirectoryName))
    }

    func testFilesIn() throws {
        let fileCount = 10

        try populateDirectoryWithFiles(count: fileCount)

        let newDirectoryName = "new"
        let newDirectoryURL = testableFileStorage.directoryURL.appendingPathComponent(newDirectoryName)
        try fileManager.createDirectoryIfNeeded(newDirectoryURL)
        try populateDirectoryWithFiles(count: fileCount,
                                   directoryURL: newDirectoryURL)


        // test files search with enumeration and default directory
        let allFilesCount = try  testableFileStorage.filesIn().count
        XCTAssertEqual(allFilesCount, fileCount*2)

        // test files search with sub directory enumeration
        let mainDirectoryFilesCount = try testableFileStorage.filesIn(enumerateDirectories: false).count
        XCTAssertEqual(mainDirectoryFilesCount, fileCount)

        // test files search at specified directory
        let newDirectoryFilesCount = try testableFileStorage.filesIn(enumerateDirectories: false, atDirectory: newDirectoryURL).count
        XCTAssertEqual(newDirectoryFilesCount, fileCount)
    }

    // populate directory with files
    private func populateDirectoryWithFiles(count: Int = 1, directoryURL: URL? = nil) throws {
        let _directoryURL = directoryURL ?? self.testableFileStorage.directoryURL
        guard count > 0 else { return }
        for n in 1...count {
            let data = Data(count: n)
            let fileURL = _directoryURL.appendingPathComponent("data\(n)")
            try data.write(to: fileURL)
        }
    }
    
}
