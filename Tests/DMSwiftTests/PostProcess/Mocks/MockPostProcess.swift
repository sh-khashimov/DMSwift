//
//  MockPostProcess.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/9/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import DMSwift

struct MockPostProcess: PostProcessing {

    var supportedFileExtensions: Set<String>

    var onComplete: ((Error?) -> Void)?

    var onProcess: (() -> Void)? = nil
    
    var onPrepare: ((_ fileStorage: FileStorage?,_ filename: String?,_ fileExtention: String?,_ sourceLocation: URL?) -> Void)? = nil

    mutating func prepare(fileStorage: FileStorage?, filename: String?, fileExtention: String?, sourceLocation: URL?) {
        onPrepare?(fileStorage, filename, fileExtention, sourceLocation)
    }

    func process() {
        onProcess?()
        onComplete?(nil)
    }


    func cancel() -> Error? {
        let error = NSError(domain: "error", code: 100, userInfo: nil)
        return error
    }


}
