//
//  SimpleExampleViewController.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 10/2/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit
import DMSwift

class SimpleExampleViewController: UIViewController, FileCountable {

    @IBOutlet weak var fileCountLabel: UILabel!
    @IBOutlet weak var fileCountSlider: UISlider!

    @IBOutlet weak var progressView: CircleProgressView!
    @IBOutlet weak var progressLabel: UILabel!

    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.defaultStyle(withText: "Start")
        }
    }
    @IBOutlet weak var stopButton: UIButton! {
        didSet {
            stopButton.defaultStyle(withText: "Stop", buttonType: .destructive)
        }
    }
    @IBOutlet weak var clearButton: UIButton! {
        didSet {
            clearButton.defaultStyle(withText: "Clear Cache", buttonType: .warning)
        }
    }

    @IBOutlet weak var showDownloadedFilesButton: UIButton! {
        didSet {
            showDownloadedFilesButton.defaultStyle(withText: "Show Downloaded Files", buttonType: .success)
        }
    }

    var fileCount: Int = 0 {
        didSet {
            fileCountUpdated()
        }
    }

    var fileCountDescription: String = "" {
        didSet {
            fileCountLabel.text = fileCountDescription
        }
    }

    private var directoryPath: String = "example/simple"

    lazy var allUrls: [URL] = {
        let urls = Data.imageUrlsStrings.map({ URL(string: $0)! })
        return urls
    }()

    lazy var urls: [URL] = []

    private lazy var downloader: DMSwift = {
        let downloader = DMSwift(path: directoryPath, logLevel: .low)

        downloader.onDownloadStarted = { [weak self] in
            self?.showLoadingRight()
        }

        downloader.onDownloadComplete = { [weak self] in
            self?.showDownloadSuccessAlert()
            self?.hideLoadingRight()
        }

        downloader.onDownloadCompletedWithError = { [weak self] failedTasks in
            self?.showFailedDownloadAlert(tasks: failedTasks) {
                downloader.download(failedTasks.map({$0.url}))
            }
            print("failed to download tasks: \(failedTasks)")
            self?.hideLoadingRight()
        }
        //
        downloader.onDownloadUpdateTaskCount = { [weak self] progress in
            self?.progressView.percent = CGFloat(progress.progress)
            self?.progressLabel.text = "\(Int(progress.progress*100))%"
        }

        return downloader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        fileCountSlider.maximumValue = Float(allUrls.count)
        fileCount = Int(fileCountSlider.value)
        fileCountUpdated()

        self.navigationItem.title = "Simple Example"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FileBrowserViewController {
            vc.configure(with: directoryPath)
        }
    }


    @IBAction func startDownloadAction(_ sender: Any) {
        downloadImages()
    }

    @IBAction func stopDownloadAction(_ sender: Any) {
        cancel()
    }

    @IBAction func clearCacheAction(_ sender: Any) {
        clearCache()
    }

    @IBAction func fileCountValueChanged(_ sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        fileCount = Int(roundedValue)
    }

    @IBAction func showDownloadFilesAction(_ sender: Any) {
        self.performSegue(withIdentifier: "show\(FileBrowserViewController.self)", sender: nil)
    }


    private func downloadImages() {
        cancel()
        downloader.download(urls)
    }

    private func cancel() {
        downloader.cancel()
    }

    private func clearCache() {
        downloader.removeFilesFromDirectory()
    }
}

extension SimpleExampleViewController: DownloadsPresentable {}
