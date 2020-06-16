//
//  FileWritingTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 11/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift


fileprivate struct TestableFileStorage: FileStorageManageable, FileWriting {
    var configuration: FileStorageConfiguration
    var path: String?
    var fileManager: FileManager = FileManager()
}

class FileWritingTests: XCTestCase {

    fileprivate var directoryPath = Const.Path.Test
    fileprivate var configuration = DefaultFileStorageConfiguration()
    fileprivate var testableFileStorage: TestableFileStorage!
    fileprivate let fileManager = FileManager()

    fileprivate var domain = Const.Domain.Default
    fileprivate let filename = "1"
    fileprivate let fileExtension = "tmp"
    fileprivate let filespecExtention = "json"
    fileprivate var fileURL: URL!
    fileprivate var fileURLMD5: URL!
    fileprivate var hiddenFileURLMD5: URL!
    fileprivate var fullFileURL: URL!
    fileprivate var urlWithFilename: URL!
    fileprivate var urlWithoutFilename: URL!
    fileprivate var urlWithIncorrectFilename: URL!
    fileprivate var urlWithFilenameAndExtension: URL!
    fileprivate var newFileURL: URL!
    fileprivate var newFileURLMD5: URL!
    fileprivate var hiddenNewFileURLMD5: URL!
    fileprivate var newDirectoryURL: URL!
    fileprivate let filesize = 1
    fileprivate var data: Data!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testableFileStorage = TestableFileStorage(configuration: configuration, path: directoryPath)
        testableFileStorage.createDirectoryIfNeeded()

        data = Data(count: filesize)

        fileURL = testableFileStorage.directoryURL.appendingPathComponent(filename)
        fullFileURL = fileURL.appendingPathExtension(fileExtension)

        urlWithoutFilename = URL(string: domain)!
        urlWithFilename = URL(string: "\(domain)\(filename)")!
        fileURLMD5 = testableFileStorage.directoryURL.appendingPathComponent(urlWithFilename.absoluteString.MD5)
        hiddenFileURLMD5 = testableFileStorage.directoryURL.appendingPathComponent(".\(urlWithFilename.absoluteString.MD5)")
        urlWithFilenameAndExtension = URL(string: "\(domain)\(filename).\(fileExtension)")!
        urlWithIncorrectFilename = URL(string: "\(domain)assss\(filename).\(fileExtension)")!
        newDirectoryURL = testableFileStorage.directoryURL.appendingPathComponent("new")
        newFileURL = newDirectoryURL.appendingPathComponent(filename)
        newFileURLMD5 = newDirectoryURL.appendingPathComponent(urlWithFilename.absoluteString.MD5)
        hiddenNewFileURLMD5 = newDirectoryURL.appendingPathComponent(".\(urlWithFilename.absoluteString.MD5)")
        testableFileStorage.createDirectoryIfNeeded(newDirectoryURL)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try? testableFileStorage.removeDirectory()
    }


    static var allTests = [
        ("testCreateFile", testCreateFile),
        ("testCreateFilespec", testCreateFilespec),
        ("testMoveAndRename", testMoveAndRename),
        ("testRemoves", testRemoves)
    ]

    func testCreateFile() {

        // check if a file was created
        var isFileSaved = testableFileStorage.createFile(from: data, filename: filename)
        XCTAssertTrue(isFileSaved)
        XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path))

        // check if a file with extension was created
        isFileSaved = testableFileStorage.createFile(from: data, filename: filename, fileExtension: fileExtension)
        XCTAssertTrue(isFileSaved)
        XCTAssertTrue(fileManager.fileExists(atPath: fullFileURL.path))

        // check if a file was created to new directory
        isFileSaved = testableFileStorage.createFile(from: data, toDirectory: newDirectoryURL, filename: filename)
        XCTAssertTrue(isFileSaved)
        XCTAssertTrue(fileManager.fileExists(atPath: newFileURL.path))

    }

    func testCreateFilespec() throws {

        try data.write(to: fullFileURL)

        var filespec = Filespec(url: urlWithFilename, path: fullFileURL.path, name: filename, filename: filename, fileExtension: fileExtension, size: Int64(filesize), searchPathDirectoryId: nil)

        // check if filespec successfully save
        var isFileSaved = testableFileStorage.createFilespec(filespec)
        XCTAssertTrue(isFileSaved)
        var filescpecURL = hiddenFileURLMD5.appendingPathExtension(filespecExtention)
        XCTAssertTrue(fileManager.fileExists(atPath: filescpecURL.path))

        // check if filespec successfully save to specified directory
        isFileSaved = testableFileStorage.createFilespec(filespec, toDirectory: newDirectoryURL)
        XCTAssertTrue(isFileSaved)
        filescpecURL = hiddenNewFileURLMD5.appendingPathExtension(filespecExtention)
        XCTAssertTrue(fileManager.fileExists(atPath: filescpecURL.path))

        // Filespec filename is nil, create file should be unsuccess
        filespec = Filespec()
        isFileSaved = testableFileStorage.createFilespec(filespec)
        XCTAssertFalse(isFileSaved)
        filescpecURL = fileURL.appendingPathExtension(filespecExtention)
        XCTAssertFalse(fileManager.fileExists(atPath: filescpecURL.path))

    }

    func testMoveAndRename() throws {

        // populates a file
        try data.write(to: fileURL)

        // tests if file succesfully renamed (moved)
        try testableFileStorage.rename(original: fileURL, to: newFileURL)
        XCTAssertTrue(fileManager.fileExists(atPath: newFileURL.path))

        // tests if file succesfully renamed (moved)
        try testableFileStorage.moveFile(at: newFileURL, to: fileURL)
        XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path))
        try? fileManager.removeItem(at: newFileURL)

        // populates a file
        try data.write(to: fileURL)

        // tests if file succesfully renamed (moved)
        var movedFileLocation = try testableFileStorage.moveFile(at: fileURL, withFileName: filename)
        XCTAssertTrue(fileManager.fileExists(atPath: movedFileLocation.path))
        try? fileManager.removeItem(at: movedFileLocation)

        // populates a file
        try data.write(to: fileURL)

        // tests if file succesfully renamed (moved)
        movedFileLocation = try testableFileStorage.moveFile(at: fileURL, to: newDirectoryURL, withFileName: filename, fileExtension: fileExtension)
        XCTAssertTrue(fileManager.fileExists(atPath: movedFileLocation.path))
        try? fileManager.removeItem(at: movedFileLocation)
    }

    func testRemoves() throws {

        // populates a file
        try data.write(to: fullFileURL)
        XCTAssertTrue(fileManager.fileExists(atPath: fullFileURL.path))

        // removes a file with filename and extension
        try testableFileStorage.removeFile(fileName: filename, fileExtension: fileExtension)
        XCTAssertFalse(fileManager.fileExists(atPath: fileURL.path))

        // try remove a file that doesn't exists
        XCTAssertThrowsError(try testableFileStorage.removeFile(fileName: filename, fileExtension: fileExtension))

        // populates a file
        try data.write(to: fileURL)
        XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path))

        // removes a file by file location
        try testableFileStorage.removeFile(at: fileURL)
        XCTAssertFalse(fileManager.fileExists(atPath: fileURL.path))

        // populates a file
        try data.write(to: fileURL)
        XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path))
        // try remove a file with without filename url
        XCTAssertThrowsError(try testableFileStorage.removeFile(urlWithoutFilename))
        // try remove a file with incorrect filename
        XCTAssertThrowsError(try testableFileStorage.removeFile(urlWithIncorrectFilename))
        // try remove a file with remote location url
        try testableFileStorage.removeFile(urlWithFilename)
        XCTAssertFalse(fileManager.fileExists(atPath: fileURL.path))


        // populates a file
        try data.write(to: fileURL)
        XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path))

        // removes all files from directory
        try testableFileStorage.removeFilesFromDirectory()
        let mainDirectoryFilesCount = fileManager.enumerate(directory: testableFileStorage.directoryURL, enumerateDirectories: false, includeDirectories: false, includeFiles: true).count
        XCTAssertTrue(mainDirectoryFilesCount == 0)

        // creates a new directory
        try fileManager.createDirectoryIfNeeded(newDirectoryURL)
        XCTAssertTrue(fileManager.fileExists(atPath: newDirectoryURL.path))

        // removes new directory
        try testableFileStorage.removeDirectory(newDirectoryURL)
        XCTAssertFalse(fileManager.fileExists(atPath: newDirectoryURL.path))

        // populates a file to search directory
        let fileInSearchDirectoryURL = testableFileStorage.searchDirectoryURL.appendingPathComponent(filename).appendingPathExtension(fileExtension)
        try data.write(to: fileInSearchDirectoryURL)
        XCTAssertTrue(fileManager.fileExists(atPath: fileInSearchDirectoryURL.path))
    }
}
