//
//  UIViewController+RightBarLoading.swift
//  DMSwiftDemoiOS
//
//  Created by Sherzod Khashimov on 5/1/20.
//  Copyright © 2020 Sherzod Khashimov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public func showLoadingRight() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        let barButton = UIBarButtonItem(customView: activityIndicator)
        barButton.tag = 334
        navigationItem.rightBarButtonItem = barButton
        activityIndicator.startAnimating()
    }

    public func hideLoadingRight() {
        guard let barButton = self.navigationItem.rightBarButtonItem else {
            return
        }
        if barButton.tag != 334 {
            return
        }
        self.navigationItem.rightBarButtonItem = nil
    }
}
