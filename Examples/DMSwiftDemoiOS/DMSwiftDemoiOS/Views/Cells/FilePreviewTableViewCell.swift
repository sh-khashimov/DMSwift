//
//  FilePreviewTableViewCell.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/25/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit

class FilePreviewTableViewCell: UITableViewCell {

    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var warningView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        fileImageView.isHidden = true
        warningView.isHidden = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        fileImageView.isHidden = true
        warningView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FilePreviewTableViewCell {
    func configure(with fileUrl: URL?) {
        if let url = fileUrl, let image = UIImage(contentsOfFile: url.path) {
            fileImageView.image = image
            fileImageView.isHidden = false
            warningView.isHidden = true
        } else {
            fileImageView.isHidden = true
            warningView.isHidden = false
        }
    }
}
