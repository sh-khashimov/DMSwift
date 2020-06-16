//
//  PostProcessingOperationTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/9/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class PostProcessingOperationTests: XCTestCase {

    var postProcess: MockPostProcess!

    var fileStorage: FileStorage!

    let path = Const.Path.Temp

    override func setUp() {

        fileStorage = FileStorage(path: path)

        postProcess = MockPostProcess(supportedFileExtensions: ["exe"])
    }

    override func tearDown() {
        try? fileStorage.removeDirectory()
    }


    static var allTests = [
        ("testPrepareToStart", testPrepareToStart),
        ("testStart", testStart)
    ]

    func testPrepareToStart() {

        let prepareExpectation = expectation(description: "prepare")

        let complitionExpectation = expectation(description: "complete")

        let filename = "filename"
        let fileExtension = "exe"
        let sourceLocation = fileStorage.urlFor(filename: filename)

        postProcess.onPrepare = { (fileStorage, _filename, _fileExtention, _sourceLocation) in

            XCTAssertNotNil(fileStorage)
            XCTAssertEqual(filename, _filename)
            XCTAssertEqual(fileExtension, _fileExtention)
            XCTAssertEqual(sourceLocation, _sourceLocation)

            prepareExpectation.fulfill()
        }

        let operation = PostProcessingOperation(fileStorage: fileStorage, postProcessing: postProcess)

        operation.prepareToStart(withSourceLocation: sourceLocation, filename: filename, fileExtension: fileExtension)

        operation.onComplete = { error in

            // tests cancel implementation
            XCTAssertNotNil(error)

            complitionExpectation.fulfill()
        }

        operation.cancel()

        wait(for: [prepareExpectation, complitionExpectation], timeout: 5)
    }

    func testStart() {

        let processExpectation = expectation(description: "process")

        let complitionExpectation = expectation(description: "complete")

        postProcess.onProcess = {
            processExpectation.fulfill()
        }

        let operation = PostProcessingOperation(fileStorage: fileStorage, postProcessing: postProcess)

        operation.onComplete = { error in

            // tests for successfully completed status
            XCTAssertNil(error)

            complitionExpectation.fulfill()
        }

        operation.start()

        wait(for: [processExpectation, complitionExpectation], timeout: 5)
    }

}
