//
//  PostProcessQueueTests.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/9/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class PostProcessQueueTests: XCTestCase {

    let dependateOperation = MockOperation()

    var fileStorage: FileStorage!

    let path = Const.Path.Temp

    var configuration: DMSwiftConfiguration!

    var postProcessQueue: PostProcessQueue!

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

        configuration = DefaultDMSwiftConfiguration()

        postProcessQueue = PostProcessQueue(configuration: configuration, fileStorage: fileStorage, postProcessings: postProcesses)
    }

    override func tearDown() {
        try? fileStorage.removeDirectory()
    }


    static var allTests = [
        ("testQueue", testQueue)
    ]

    func testQueue() {

        let startExpectation = XCTestExpectation(description: "start")
        let finishedExpectation = XCTestExpectation(description: "finished")
        let progressExpectation = XCTestExpectation(description: "progress")

        postProcessQueue.onStarted = {
            startExpectation.fulfill()
        }

        postProcessQueue.onComplete = { failedTasks in
            XCTAssertEqual(failedTasks.count, 0)
            finishedExpectation.fulfill()
        }

        postProcessQueue.onTaskProgressUpdate = { progress in
            if progress.isFinished {
                progressExpectation.fulfill()
            }
        }

        postProcessQueue.start(withDependentOperation: dependateOperation)

        _ = postProcessQueue.addPostProcessOperation(withFileData: exeFileData)
        _ = postProcessQueue.addPostProcessOperation(withFileData: jpgFileData)
        _ = postProcessQueue.addPostProcessOperation(withFileData: pngFileData)

        dependateOperation.start()
        dependateOperation.cancel()

        wait(for: [startExpectation, finishedExpectation, progressExpectation], timeout: 5)
    }
}
