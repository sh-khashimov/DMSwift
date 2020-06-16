//
//  FileManagerExtensionTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 11/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class FileManagerExtensionTests: XCTestCase {

    fileprivate var fileManager: FileManager = FileManager()
    fileprivate var directoryURL = URL(fileURLWithPath: NSTemporaryDirectory() + "directory/path")

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        removeDirectoryIfExists()
    }


    static var allTests = [
        ("testCreateDirectoryIfNeeded", testCreateDirectoryIfNeeded),
        ("testRemoveAllFiles", testRemoveAllFiles),
        ("testFileAttributes", testFileAttributes),
        ("testEnumerate", testEnumerate)
    ]

    func testCreateDirectoryIfNeeded() throws {

        XCTAssertFalse(fileManager.fileExists(atPath: directoryURL.path), "directory already exists")

        // try create a directory if a directory doesn't exists
        try fileManager.createDirectoryIfNeeded(directoryURL)

        XCTAssertTrue(fileManager.fileExists(atPath: directoryURL.path), "directory not created")

        // try create a directory if a directory already exists
        try fileManager.createDirectoryIfNeeded(directoryURL)

        XCTAssertTrue(fileManager.fileExists(atPath: directoryURL.path), "directory not created")

        // removes directory if it exists
        try fileManager.removeItem(at: directoryURL)

        let _path = "https://domain.com"
        let _directoryURL = URL(string: _path)!

        // try create a directory with incorrect path url
        XCTAssertThrowsError(try fileManager.createDirectoryIfNeeded(_directoryURL))
    }

    func testRemoveAllFiles() throws {

        try createDirectoryIfNeeded()

        let filesCount = 10

        try populateDirectoryWithFiles(count: filesCount)

        // check if all files succesfully added
        var directoryContents = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        XCTAssertTrue(directoryContents.count == filesCount)

        // removes all files in directory
        try fileManager.removeAllFiles(atDirectory: directoryURL)

        directoryContents = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        XCTAssertTrue(directoryContents.isEmpty)

        if fileManager.fileExists(atPath: directoryURL.path) {
            // removes directory if it exists
            try? fileManager.removeItem(at: directoryURL)
        }

        // try remove all files from directory that not exists
        XCTAssertThrowsError(try fileManager.removeAllFiles(atDirectory: directoryURL))
    }

    func testFileAttributes() throws {

        try createDirectoryIfNeeded()

        // populate one file
        let data = Data(count: 1)
        let fileURL = directoryURL.appendingPathComponent("data\(1)")
        try data.write(to: fileURL)

        var fileAttributes: FileAttributes?

        // try retrieve file attributes
        XCTAssertNoThrow(fileAttributes = try fileManager.fileAttributes(at: fileURL), "couldn't get file attributes")
        XCTAssertNotNil(fileAttributes)

        removeDirectoryIfExists()
        // file not exists
        XCTAssertThrowsError(try fileManager.fileAttributes(at: fileURL))

    }

    func testEnumerate() throws {
        try createDirectoryIfNeeded()

        let filesCount = 10
        // populates 10 files to main directory
        try populateDirectoryWithFiles(count: filesCount)

        // create new directory
        let newDirectory = directoryURL.appendingPathComponent("new")
        try createDirectoryIfNeeded(directoryURL: newDirectory)

        // populates 10 files to new directory
        try populateDirectoryWithFiles(count: filesCount, directoryURL: newDirectory)

        // create second new directory
        let secondNewDirectory = directoryURL.appendingPathComponent("new/new")
        try createDirectoryIfNeeded(directoryURL: secondNewDirectory)

        let mainDirectoryFilesCount = fileManager.enumerate(directory: directoryURL, enumerateDirectories: false, includeDirectories: false, includeFiles: true).count
        print("mainDirectoryFilesCount: \(mainDirectoryFilesCount)")

        // check if files count equal to main directory files count
        XCTAssertTrue(mainDirectoryFilesCount == filesCount)

        let allFilesInMainDirectoryCount = fileManager.enumerate(directory: directoryURL, enumerateDirectories: true, includeDirectories: false, includeFiles: true).count

        // check if all files count equal to files count in all directories
        XCTAssertTrue(allFilesInMainDirectoryCount == 2*filesCount)

        let mainDirectoryDirectoriesCount = fileManager.enumerate(directory: directoryURL, enumerateDirectories: false, includeDirectories: true, includeFiles: false).count

        // check main directory, directories count
        XCTAssertTrue(mainDirectoryDirectoriesCount == 1)

        let allDirectoriesCount = fileManager.enumerate(directory: directoryURL, enumerateDirectories: true, includeDirectories: true, includeFiles: false).count

        // check all directories count
        XCTAssertTrue(allDirectoriesCount == 2)

        let allDirectoriesAndFilesCount = fileManager.enumerate(directory: directoryURL, enumerateDirectories: true, includeDirectories: true, includeFiles: true).count

        // check all files and directories count
        XCTAssertTrue(allDirectoriesAndFilesCount == 2+(2*filesCount))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    // creates directory if needed
    private func createDirectoryIfNeeded(directoryURL: URL? = nil) throws {
        let _directoryURL = directoryURL ?? self.directoryURL
        if !fileManager.fileExists(atPath: _directoryURL.path) {
            try fileManager.createDirectory(atPath: _directoryURL.path, withIntermediateDirectories: true, attributes: nil)
        }
    }

    // removes directory if it exists
    private func removeDirectoryIfExists(directoryURL: URL? = nil) {
        let _directoryURL = directoryURL ?? self.directoryURL
        if fileManager.fileExists(atPath: _directoryURL.path) {
            try? fileManager.removeItem(at: _directoryURL)
        }
    }

    // populate directory with files
    private func populateDirectoryWithFiles(count: Int = 1, directoryURL: URL? = nil) throws {
        let _directoryURL = directoryURL ?? self.directoryURL
        guard count > 0 else { return }
        for n in 1...count {
            let data = Data(count: n)
            let fileURL = _directoryURL.appendingPathComponent("data\(n)")
            try data.write(to: fileURL)
        }
    }
}
