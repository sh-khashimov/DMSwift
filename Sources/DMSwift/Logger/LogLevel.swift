//
//  LogLevel.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/31/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

public enum LogLevel: Int {
    case none = 0, low = 1, medium = 2, high = 3

    func isLogLevelSatisfied(with logLevel: LogLevel) -> Bool {
        return self.rawValue >= logLevel.rawValue
    }
}
