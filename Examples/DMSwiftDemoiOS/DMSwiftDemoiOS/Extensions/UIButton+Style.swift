//
//  UIButton+Style.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/23/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func defaultStyle(withText text: String, buttonType: UIButtonType = .normal) {
        self.layer.cornerRadius = 5
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        self.setTitle(text.uppercased(), for: .normal)
        self.setTitle(text.uppercased(), for: .highlighted)

        switch buttonType {
        case .normal:
            self.backgroundColor = .systemBlue
        case .destructive:
            self.backgroundColor = .systemRed
        case .neutral:
            self.backgroundColor = .systemGray2
        case .warning:
            self.backgroundColor = .systemOrange
        case .success:
            self.backgroundColor = .systemGreen
        }

        switch buttonType {
        default:
            self.setTitleColor(.systemBackground, for: .normal)
        }
    }
}
