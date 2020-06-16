//
//  ImageCollectionViewCell.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/25/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit
import DMSwift

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!

    weak var downloader: DMSwift?

    var imageUrl: URL?

    func loadImage() {
        guard let imageUrl = self.imageUrl else { return }
        downloader?.download(imageUrl) { [weak self] (fileLocation, imageUrl, error) in
            guard error == nil else {
                return
            }
            guard let path = fileLocation?.path,
                let image = UIImage(contentsOfFile: path) else { return }
            self?.imageView.alpha = 0
            self?.imageView.image = image
            UIView.animate(withDuration: 0.3) {
                self?.imageView.alpha = 1
            }
        }
        downloader?.download(imageUrl)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = nil
        errorLabel.isHidden = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        errorLabel.isHidden = true
    }
}

extension ImageCollectionViewCell {
    func configure(with downloader: DMSwift?, imageUrl: URL?) {
        self.downloader = downloader
        self.imageUrl = imageUrl
    }
}
