//
//  FileStorageManageableTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 11/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift


fileprivate struct TestableFileStorage: FileStorageManageable {
    var configuration: FileStorageConfiguration
    var path: String?
    var fileManager: FileManager = FileManager()
}

class FileStorageManageableTests: XCTestCase {

    fileprivate var directoryPath = Const.Path.Test
    fileprivate var configuration = DefaultFileStorageConfiguration()
    fileprivate var testableFileStorage: TestableFileStorage!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testableFileStorage = TestableFileStorage(configuration: configuration, path: directoryPath)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    static var allTests = [
        ("testComputedVariables", testComputedVariables),
        ("testUrlConvertor", testUrlConvertor)
    ]

    func testComputedVariables() {

        let fileManager = FileManager()

        let searchDirectoryURL = fileManager.urls(for: configuration.searchPathDirectory, in: .userDomainMask).first!
        XCTAssertEqual(testableFileStorage.searchDirectoryURL, searchDirectoryURL)

        let directoryURL = searchDirectoryURL.appendingPathComponent(directoryPath, isDirectory: true)
        XCTAssertEqual(testableFileStorage.directoryURL, directoryURL)

        let testableFileStorage = TestableFileStorage(configuration: configuration)
        XCTAssertEqual(testableFileStorage.directoryURL, searchDirectoryURL)
    }

    func testUrlConvertor() {

        let fileManager = FileManager()
        let searchDirectoryURL = fileManager.urls(for: configuration.searchPathDirectory, in: .userDomainMask).first!
        let directoryURL = searchDirectoryURL.appendingPathComponent(directoryPath)
        let path = "path"
        let pathURL = directoryURL.appendingPathComponent(path)

        XCTAssertEqual(testableFileStorage.urlFor(directoryPath: path), pathURL)

        let filename = "1"
        let filenameURL = directoryURL.appendingPathComponent(filename)
        let fileExtension = "exe"
        let fileExtensionURL = filenameURL.appendingPathExtension(fileExtension)

        XCTAssertEqual(testableFileStorage.urlFor(filename: filename), filenameURL)
        XCTAssertEqual(testableFileStorage.urlFor(filename: filename, fileExtension: fileExtension), fileExtensionURL)

        let urlWithoutFilename = URL(string: Const.Domain.Default)!
        let urlWithFilename = URL(string: "\(Const.Domain.Default)filename.exe")!

        XCTAssertNil(testableFileStorage.urlFor(urlWithoutFilename))
        XCTAssertNotNil(testableFileStorage.urlFor(urlWithFilename))

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
