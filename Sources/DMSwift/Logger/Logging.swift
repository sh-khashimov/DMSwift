//
//  Logging.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/12/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

protocol Logging {
    var logLevel: LogLevel { get set }
    func logError(_ error: Error)
    func log(with message: String, level: LogLevel)
}
