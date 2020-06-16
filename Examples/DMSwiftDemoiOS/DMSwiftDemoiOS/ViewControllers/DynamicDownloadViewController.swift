//
//  DynamicDownloadViewController.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit
import DMSwift

class DynamicDownloadViewController: UIViewController {

    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet weak var urlsTextView: UITextView! {
        didSet {
            urlsTextView.layer.cornerRadius = 5
            urlsTextView.layer.borderWidth = 1
            urlsTextView.layer.borderColor = UIColor.systemGray2.cgColor
            urlsTextView.delegate = self
        }
    }

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

    @IBOutlet weak var taskProgressLabel: UILabel!
    @IBOutlet weak var taskProgressView: UIProgressView!

    private var directoryPath: String = "example/dynamic"

    lazy var urls: [URL] = []

    private lazy var downloadManager: DMSwift = {
        let downloadManager = DMSwift(path: directoryPath, logLevel: .high)
        downloadManager.downloadProgressDelegate = self
        return downloadManager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        urlsTextView.inputAccessoryView = toolBar

        reset()

        self.navigationItem.title = "Custom URL Download Example"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let fileBrowserVC = segue.destination as? FileBrowserViewController {
            fileBrowserVC.configure(with: directoryPath)
        }
    }

    @IBAction func keyboardDoneAction(_ sender: Any) {
        self.view.endEditing(true)
    }


    @IBAction func startAction(_ sender: Any) {
        createUrls(from: urlsTextView.text)
        downloadManager.download(urls)
    }

    @IBAction func stopAction(_ sender: Any) {
        downloadManager.cancel()
    }

    @IBAction func clearAction(_ sender: Any) {
        downloadManager.removeFilesFromDirectory()
    }

    @IBAction func showDownloadedFilesAction(_ sender: Any) {
        self.performSegue(withIdentifier: "show\(FileBrowserViewController.self)", sender: nil)
    }

}

extension DynamicDownloadViewController {

    func reset() {
        taskProgressView.progress = 0
        taskProgressLabel.text = "Downloaded Task Status"
    }

    func createUrls(from string: String) {
        self.urls = []
        let _urls = string.replacingOccurrences(of: "\n", with: "").split(separator: ",")
            .map({ String($0.trimmingCharacters(in: .whitespacesAndNewlines)) })
            .map({ URL(string: $0) })
            .filter({ $0 != nil })
            .map({ $0! })
        self.urls = _urls
    }
}

extension DynamicDownloadViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        //
    }
}

extension DynamicDownloadViewController: DownloaderProgressDelegate {

    func downloadDidUpdate(progress: Float, downloadedSize: Int64, totalSize: Int64) {
        //
    }

    func downloadDidUpdate(progress: Float, finishedTaskCount: Int64, taskCount: Int64) {
        taskProgressView.progress = progress

        taskProgressLabel.text = "Downloaded \(finishedTaskCount) from \(taskCount)"
    }

    func downloadStarted() {
        reset()
    }

    func downloadDidComplete() {
        showDownloadSuccessAlert()
    }

    func downloadDidCompletedWithError(tasks: [DMSwiftTypealias.Download.FailedTask]) {
        showFailedDownloadAlert(tasks: tasks) { [weak self] in
            //re-download
            self?.downloadManager.download(tasks.map({ $0.url }))
        }
    }
}

extension DynamicDownloadViewController: DownloadsPresentable {}
