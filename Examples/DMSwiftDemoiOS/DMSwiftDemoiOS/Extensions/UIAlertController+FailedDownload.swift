//
//  UIAlertController+FailedDownload.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/26/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit

extension UIAlertController {

    static func failedDownloadAlert(taskCount: Int, handler: @escaping (() -> Void)) -> UIAlertController {
        let title = "unfortunately could not download \(taskCount) file(s), download only this/these file(s) again?"
        return self.dialog(title: title, handler: handler)
    }

    static func dialog(title: String, handler: @escaping (() -> Void)) -> UIAlertController {

        let alertView = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let noAlertAction = UIAlertAction(title: "NO", style: .cancel) { (actions) in
            alertView.dismiss(animated: true, completion: nil)
        }
        let yesAlertAction = UIAlertAction(title: "YES", style: .default) { (action) in
            handler()
        }
        alertView.addAction(noAlertAction)
        alertView.addAction(yesAlertAction)
        return alertView
    }
}
