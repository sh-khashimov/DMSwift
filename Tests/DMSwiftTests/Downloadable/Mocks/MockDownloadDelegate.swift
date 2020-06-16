//
//  MockDownloadDelegate.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/7/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import XCTest
@testable import DMSwift

class MockDownloadDelegate: DownloadDelegate {

    var expectation: XCTestExpectation?

    var onReciveFileSize: ((Int64) -> Void)?

    var onUpdateProgress: ((DMSwiftTypealias.Download.ProgressData) -> Void)?

    var completionHandler: ((DMSwiftTypealias.Download.FileData) -> Void)?

    var onFileDataChange: ((DMSwiftTypealias.Download.SavedFileData?) -> Void)?

    init(expectation: XCTestExpectation? = nil) {
        self.expectation = expectation
    }

    func received(fileSize: Int64) {
        onReciveFileSize?(fileSize)
        expectation?.fulfill()
    }

    func updated(_ progress: DMSwiftTypealias.Download.ProgressData) {
        onUpdateProgress?(progress)
        expectation?.fulfill()
    }

    func completed(_ data: DMSwiftTypealias.Download.FileData) {
        completionHandler?(data)
        expectation?.fulfill()
    }

    func fileData(_ fileData: DMSwiftTypealias.Download.SavedFileData) {
        onFileDataChange?(fileData)
        expectation?.fulfill()
    }


}
