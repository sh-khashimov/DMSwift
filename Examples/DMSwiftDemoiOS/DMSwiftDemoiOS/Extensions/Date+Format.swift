//
//  UIDate+Format.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/25/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

extension Date {

    func format(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
