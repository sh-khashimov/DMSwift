//
//  FileCountable.swift
//  DemoiOS
//
//  Created by Sherzod Khashimov on 12/30/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

protocol FileCountable: class {
    var urls: [URL] { get set }
    var allUrls: [URL] { get set }
    var fileCount: Int { get set }
    var fileCountDescription: String { get set }
}

extension FileCountable {

    func fileCountUpdated() {
        fileCountDescription = "File count: \(fileCount)"
        urls = Array(allUrls.prefix(fileCount))
    }
}
