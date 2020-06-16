//
//  MockOperation.swift
//  DMSwiftTests
//
//  Created by Sherzod Khashimov on 12/9/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import DMSwift

class MockOperation: DefaultOperation {

    public var onComplete: (() -> Void)?

    override public func start() {
        if(self.isCancelled) {
            //TODO: Error
            self.onComplete?()
            state = .finished
            return
        }

        state = .executing
    }

    override public func cancel() {
        // cancel the downloading
        self.onComplete?()
        state = .finished
    }
}
