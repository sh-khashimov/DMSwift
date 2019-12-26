//
//  SynchronizedArray.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 10/4/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

/// A thread-safe array.
public class SynchronizedArray<Element> {
    private let queue = DispatchQueue(label: "com.downloader.SynchronizedArray", attributes: .concurrent)
    private var array = [Element]()
}

public extension SynchronizedArray {

    var synchronizedArray: [Element] {
        var array: [Element] = []
        queue.sync {
            array = self.array
        }
        return array
    }

    var count: Int {
        var count = 0
        queue.sync {
            count = self.array.count
        }
        return count
    }

    func append(_ element: Element) {
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }

    func clear() {
        queue.async(flags: .barrier) {
            self.array.removeAll()
        }
    }
}
