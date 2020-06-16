//
//  AdvancedExampleViewController.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit
import DMSwift

class AdvancedExampleViewController: UIViewController, FileCountable {

    @IBOutlet weak var fileCountLabel: UILabel!
    @IBOutlet weak var fileCountSlider: UISlider!

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
    @IBOutlet weak var hashFilenameSwitch: UISwitch!
    @IBOutlet weak var fileSpecSwitch: UISwitch!

    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet weak var cancelCountTextField: UITextField! {
        didSet {
            cancelCountTextField.delegate = self
        }
    }

    @IBOutlet weak var taskProgressLabel: UILabel!
    @IBOutlet weak var taskProgressView: UIProgressView!

    @IBOutlet weak var downloadProgressLabel: UILabel!
    @IBOutlet weak var downloadProgressView: UIProgressView!

    @IBOutlet weak var concurentLabel: UILabel!
    @IBOutlet weak var concurentSlider: UISlider!

    @IBOutlet weak var taskTypeSegmentedControl: UISegmentedControl!

    private var cancelCount: Double?
    private var cancelTimer: Timer?

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

    private var directoryPath: String = "example/advanced"

    lazy var allUrls: [URL] = {
        let urls = Data.imageUrlsStrings.map({ URL(string: $0)! })
        return urls
    }()

    lazy var urls: [URL] = []

    private lazy var downloadManager: DMSwift = {
        let downloadManager = DMSwift(path: directoryPath, logLevel: .high)
        downloadManager.downloadProgressDelegate = self
        return downloadManager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Advanced Example"

        cancelCountTextField.inputAccessoryView = toolBar

        concurentSlider.value = Float(downloadManager.configuration.downloadMaxConcurrentOperationCount)
        concurentLabel.text = "Concurent download task: \(Int(concurentSlider.value))"

        switch downloadManager.configuration.urlSessionTaskType {
        case .dataTask:
            taskTypeSegmentedControl.selectedSegmentIndex = 0
        case .downloadTask:
            taskTypeSegmentedControl.selectedSegmentIndex = 1
        }

        hashFilenameSwitch.isOn = downloadManager.fileStorage.configuration.useHashedPathForFilename
        fileSpecSwitch.isOn = downloadManager.fileStorage.configuration.createFilespec

        fileCountSlider.maximumValue = Float(allUrls.count)
        fileCount = Int(fileCountSlider.value)
        fileCountUpdated()

        reset()
    }
    

    @IBAction func startAction(_ sender: Any) {
        downloadManager.download(urls)
        if let cancelCount = self.cancelCount {
            self.cancelTimer = Timer.scheduledTimer(withTimeInterval: cancelCount, repeats: false, block: { [weak self] (timer) in
                self?.downloadManager.cancel()
            })
        }
    }

    @IBAction func stopAction(_ sender: Any) {
        downloadManager.cancel()
        cancelTimer?.invalidate()
    }

    @IBAction func clearAction(_ sender: Any) {
        downloadManager.removeFilesFromDirectory()
    }

    @IBAction func showDownloadedFilesAction(_ sender: Any) {
        self.performSegue(withIdentifier: "show\(FileBrowserViewController.self)", sender: nil)
    }

    @IBAction func concurentChanged(_ sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        downloadManager.configuration.downloadMaxConcurrentOperationCount = Int(sender.value)
        concurentLabel.text = "Concurent download task: \(Int(sender.value))"
    }

    @IBAction func typeChanged(_ sender: UISegmentedControl) {
        downloadManager.configuration.urlSessionTaskType = sender.selectedSegmentIndex == 0 ? .dataTask : .downloadTask
    }

    @IBAction func keyboardDoneAction(_ sender: Any) {
        self.view.endEditing(true)
        cancelCount = Double(cancelCountTextField.text ?? "")
    }

    @IBAction func hashFilenameValueChanged(_ sender: UISwitch) {
        downloadManager.fileStorage.configuration.useHashedPathForFilename = sender.isOn
    }

    @IBAction func fileSpecValueChanged(_ sender: UISwitch) {
        downloadManager.fileStorage.configuration.createFilespec = sender.isOn
    }

    @IBAction func fileCountValueChanged(_ sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        fileCount = Int(roundedValue)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let fileBrowserVC = segue.destination as? FileBrowserViewController {
            fileBrowserVC.configure(with: directoryPath)
        }
    }

}

extension AdvancedExampleViewController {

    func reset() {
        downloadProgressView.progress = 0
        downloadProgressLabel.text = "Download Size Status"

        taskProgressView.progress = 0
        taskProgressLabel.text = "Downloaded Task Status"
    }
}

extension AdvancedExampleViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        cancelCount = Double(textField.text ?? "")
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            guard updatedText.count > 0 else { return true }
            guard Double(updatedText) != nil else { return false }
            return true
        }
        return false
    }
}

extension AdvancedExampleViewController: DownloaderProgressDelegate {

    func downloadDidUpdate(progress: Float, downloadedSize: Int64, totalSize: Int64) {
        downloadProgressView.progress = progress
        downloadProgressLabel.text = "Donwloaded \(Int(downloadedSize/1024/1024)) MB from \(Int(totalSize/1024/1024)) MB"
    }

    func downloadDidUpdate(progress: Float, finishedTaskCount: Int64, taskCount: Int64) {
        taskProgressView.progress = progress

        taskProgressLabel.text = "Downloaded \(finishedTaskCount) from \(taskCount)"
    }

    func downloadStarted() {
        reset()
        self.showLoadingRight()
    }

    func downloadDidComplete() {
        showDownloadSuccessAlert()
        self.hideLoadingRight()
    }

    func downloadDidCompletedWithError(tasks: [DMSwiftTypealias.Download.FailedTask]) {
        showFailedDownloadAlert(tasks: tasks) { [weak self] in
            //TODO: re-download
            self?.downloadManager.download(tasks.map({ $0.url }))
        }
        self.hideLoadingRight()
    }
}

extension AdvancedExampleViewController: DownloadsPresentable {}
