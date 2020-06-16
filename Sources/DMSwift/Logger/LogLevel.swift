//
//  LogLevel.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/31/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// Log-level
public enum LogLevel: Int {
    case none = 0, low = 1, medium = 2, high = 3

    /// Checks if log-level is satisfactory
    /// - Parameter logLevel: A log-level.
    /// - Returns: `Bool`
    func isLogLevelSatisfied(with logLevel: LogLevel) -> Bool {
        return self.rawValue >= logLevel.rawValue
    }
}
