//
//  FileBrowserViewController.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit
import DMSwift

class FileBrowserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    private lazy var fileBrowserViewController: FileBrowserViewController? = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FileBrowserViewController") as? FileBrowserViewController
        return vc
    }()

    private lazy var fileStorageConfiguration: FileStorageConfiguration = {
        let configuration = DefaultFileStorageConfiguration()
        return configuration
    }()

    private(set) var directoryPath: String? {
        didSet {
            guard directoryPath != oldValue else { return }
            fileStorage = FileStorage(path: directoryPath, configuration: fileStorageConfiguration)
        }
    }

    private var fileStorage: FileStorage?

    var filespecs: [Filespec]?
    var files: [URL]?
    var directories: [URL]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Files Browser"
        // Do any additional setup after loading the view.
    }

    func configure(with directoryPath: String) {
        self.directoryPath = directoryPath
        filespecs = try? fileStorage?.filespecs()
        directories = try? fileStorage?.directories()
        if filespecs == nil || filespecs?.count == 0 {
            files = try? fileStorage?.filesIn()
        }
        updateViews()
    }

    func updateViews() {
        guard isViewLoaded else { return }
        tableView.reloadData()
    }

    func showFileInfo(for row: Int) {
        var fileUrl: URL? = nil
        var filespec: Filespec? = nil
        if isFilespecsAvailable {
            filespec = filespecs?[row]
            if let path = filespec?.path {
                fileUrl = URL(fileURLWithPath: path)
            }
        } else {
            fileUrl = files?[row]
        }
        self.performSegue(withIdentifier: "show\(FileInspectorViewController.self)", sender: filespec ?? fileUrl)
    }

    func showFileBrowser(for row: Int) {
        guard let fileBrowserViewController = self.fileBrowserViewController else { return }
        guard let directoryPath = self.directoryPath else { return }
        guard let directory = directories?[row] else { return }
        let directoryName = directory.lastPathComponent
        let newDirectoryPath = directoryPath + "/" + directoryName
        self.navigationController?.pushViewController(fileBrowserViewController, animated: true)
        fileBrowserViewController.configure(with: newDirectoryPath)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let fileInfoVC = segue.destination as? FileInspectorViewController {
            if let filespec = sender as? Filespec, let path = filespec.path  {
                let fileUrl = URL(fileURLWithPath: path)
                fileInfoVC.configure(with: fileUrl, filespec: filespec)
            } else if let fileUrl = sender as? URL {
                fileInfoVC.configure(with: fileUrl)
            }
        }
    }

}

extension FileBrowserViewController: FileBrowserTableViewDataSourceManageable {}

extension FileBrowserViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowInSection(section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: tableView, at: indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        switch cell?.tag {
        case 1:
            showFileBrowser(for: indexPath.row)
        case 2:
            showFileInfo(for: indexPath.row)
        default:
            break
        }
    }
}
