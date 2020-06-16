//
//  GroupPostProcessingOperationTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/9/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class GroupPostProcessingOperationTests: XCTestCase {

    var fileStorage: FileStorage!

    let path = Const.Path.Temp

    var postProcesses: [PostProcessing] {
        var postProcesses: [PostProcessing] = []

        let postProcess1 = MockPostProcess(supportedFileExtensions: ["exe"])
        postProcesses.append(postProcess1)

        let postProcess2 = MockPostProcess(supportedFileExtensions: ["jpg"])
        postProcesses.append(postProcess2)

        return postProcesses
    }

    var exeFileData: DMSwiftTypealias.Download.SavedFileData {
        let filename = "filename1"
        let fileExtension = "exe"
        let location = fileStorage.urlFor(filename: filename, fileExtension: fileExtension)
        return (location: location, filename: filename, fileExtension: fileExtension)
    }

    var jpgFileData: DMSwiftTypealias.Download.SavedFileData {
        let filename = "filename2"
        let fileExtension = "jpg"
        let location = fileStorage.urlFor(filename: filename, fileExtension: fileExtension)
        return (location: location, filename: filename, fileExtension: fileExtension)
    }

    var pngFileData: DMSwiftTypealias.Download.SavedFileData {
        let filename = "filename3"
        let fileExtension = "png"
        let location = fileStorage.urlFor(filename: filename, fileExtension: fileExtension)
        return (location: location, filename: filename, fileExtension: fileExtension)
    }

    override func setUp() {
        fileStorage = FileStorage(path: path)
    }

    override func tearDown() {
        try? fileStorage.removeDirectory()
    }


    static var allTests = [
        ("testOverExeFile", testOverExeFile),
        ("testOverJpgFileWithCancel", testOverJpgFileWithCancel)
    ]

    func testOverExeFile() {

        let completeExpectation = XCTestExpectation(description: "complete")

        let groupOperation = GroupPostProcessingOperation(fileStorage: fileStorage, postProcessings: postProcesses)

        groupOperation.onComplete = { failedTasks in
            XCTAssertEqual(failedTasks.count, 0)
            completeExpectation.fulfill()
        }

        groupOperation.prepareToStart(withSourceLocation: exeFileData.location!, filename: exeFileData.filename!, fileExtension: exeFileData.fileExtension!)

        groupOperation.start()

        wait(for: [completeExpectation], timeout: 5)
    }

    func testOverJpgFileWithCancel() {

        let completeExpectation = XCTestExpectation(description: "complete")

        let groupOperation = GroupPostProcessingOperation(fileStorage: fileStorage, postProcessings: postProcesses)

        groupOperation.onComplete = { failedTasks in
        XCTAssertEqual(failedTasks.count, 1)
            completeExpectation.fulfill()
        }

        groupOperation.prepareToStart(withSourceLocation: jpgFileData.location!, filename: jpgFileData.filename!, fileExtension: jpgFileData.fileExtension!)

        groupOperation.cancel()

        wait(for: [completeExpectation], timeout: 5)
    }
}
