//
//  ImagesCollectionViewController.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit
import DMSwift

class ImagesCollectionViewController: UIViewController {

    private var spacing: CGFloat = 1
    private var grid: CGFloat = 2

    private let imageDirectoryPath = "example/cache"

    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlow = UICollectionViewFlowLayout()
        collectionViewFlow.sectionInset = .zero
        collectionViewFlow.scrollDirection = .vertical
        collectionViewFlow.minimumInteritemSpacing = spacing
        collectionViewFlow.minimumLineSpacing = spacing
        collectionViewFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return collectionViewFlow
    }()

    var imageUrls: [URL] = []

    private lazy var downloader: DMSwift = {
        let downloader = DMSwift(path: imageDirectoryPath)
        return downloader
    }()

    private var itemSize: CGSize {
        let collectionViewWidth = collectionView.frame.size.width

        let itemWidth = (collectionViewWidth - spacing) / grid
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        return itemSize
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self

            collectionViewFlowLayout.itemSize = itemSize
            collectionView.collectionViewLayout = collectionViewFlowLayout
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageUrls = Data.smallImageUrlsStrings.map({ URL(string: $0)! })
        // Do any additional setup after loading the view.

        self.navigationItem.title = "Image Download Example"
    }
    

    @IBAction func removeAction(_ sender: Any) {
        showRemoveImages()
    }

    func showRemoveImages() {
        let alert = UIAlertController.dialog(title: "Are you sure want to remove all images from cache folder?") { [weak self] in
            guard let imageDirectoryPath = self?.imageDirectoryPath else { return }
            let fileStorage = FileStorage(path: imageDirectoryPath)
            try? fileStorage.removeFilesFromDirectory()
            self?.collectionView.reloadData()
        }
        self.present(alert, animated: true, completion: nil)
    }

}

extension ImagesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ImageCollectionViewCell.self)", for: indexPath) as? ImageCollectionViewCell
        let url = imageUrls[indexPath.row]
        cell?.configure(with: downloader, imageUrl: url)
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let _cell = cell as? ImageCollectionViewCell else { return }
        _cell.loadImage()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let _cell = cell as? ImageCollectionViewCell, let imageUrl = _cell.imageUrl else { return }
        _cell.downloader?.cancel(imageUrl)
    }
}
