//
//  HTTPURLResponse+Status.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 12/23/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

extension HTTPURLResponse {

    /// Wrap HTTP response status code to status code with success status
    var statusWithSuccess: (code: Int, isSuccess: Bool) {
        let code = self.statusCode
        switch code {
        case 200..<300:
            return (code, true)
        default:
            return (code, false)
        }
    }
}
