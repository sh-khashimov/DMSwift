//
//  Logger.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

class Logger: Logging {

    var logLevel: LogLevel = .none

    static let shared = Logger()

    func logError(_ error: Error) {
        log(with: "\(error.localizedDescription)", level: .low)
    }

    func log(with message: String, level: LogLevel) {
        guard logLevel.isLogLevelSatisfied(with: level) else { return }
        print("\(message)")
        print("-------------")
    }

    private init() { }
}

extension Logger: DownloadLogging {}

extension Logger: PostProcessLogging {}

extension Logger: FileStorageLogging {}

