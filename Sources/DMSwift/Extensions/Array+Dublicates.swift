//
//  Array+Dublicates.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 9/26/19.
//  Copyright © 2019 Unitel OOO. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {

    /// Remove duplicates from `Array`
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    /// Remove duplicates from `Array`
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
