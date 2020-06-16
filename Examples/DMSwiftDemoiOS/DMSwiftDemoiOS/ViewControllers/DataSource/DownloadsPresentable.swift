//
//  DownloadsPresentable.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/26/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit

protocol DownloadsPresentable where Self: UIViewController {
    func showFailedDownloadAlert(tasks: [(url: URL, error: Error?)], handler: @escaping (() -> Void))
    func showDownloadSuccessAlert()
}

extension DownloadsPresentable {
    func showFailedDownloadAlert(tasks: [(url: URL, error: Error?)], handler: @escaping (() -> Void)) {
        let alert = UIAlertController.failedDownloadAlert(taskCount: tasks.count, handler: handler)
        self.present(alert, animated: true, completion: nil)
    }

    func showDownloadSuccessAlert() {
        let alert = UIAlertController(title: "All files succesfully downloaded", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
