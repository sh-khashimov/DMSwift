//
//  Operation+State.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 9/6/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

public extension Operation {

    /// OperationState is used to know how to manage by OperationQueue
    enum OperationState: Int {
        case ready
        case executing
        case finished
    }
}
