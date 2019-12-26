//
//  DefaultOperation.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/7/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation


/// Custom default `Operation` class that used to use `OperationState` enum.
open class DefaultOperation: Operation {

    /// Enum representation of `Operation` status, used instead of KVO.
    /// Default state is pending (when the operation is created).
    public var state: OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }

        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }

    override public var isReady: Bool { return super.isReady && state == .ready }
    override public var isFinished: Bool { return state == .finished }
    override public var isExecuting: Bool { return state == .executing }
    override public var isAsynchronous: Bool { return true }
}
