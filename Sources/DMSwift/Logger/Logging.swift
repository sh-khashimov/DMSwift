//
//  Logging.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// Logging
protocol Logging {

    /// Log-level
    var logLevel: LogLevel { get set }

    /// Logs an error
    /// - Parameter error: `Error`
    func logError(_ error: Error)

    /// Logs a message, if specified log-level is satisfactory
    /// - Parameters:
    ///   - message: a message
    ///   - level: a log-level
    func log(with message: String, level: LogLevel)
}
