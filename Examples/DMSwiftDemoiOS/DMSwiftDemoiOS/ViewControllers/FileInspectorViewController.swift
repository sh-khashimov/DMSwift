//
//  FileInspectViewController.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/24/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit
import DMSwift

class FileInspectorViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    enum SectionType {
        case filespec
        case fileAttribues
        case preview
    }

    var fileUrl: URL?
    var filespec: Filespec?

    var filespecParams: [FileParams] = []
    var fileAttributesParams: [FileParams] = []

    private var fileAttributes: FileAttributes?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "File Inspector"
        // Do any additional setup after loading the view.
    }

    func configure(with fileUrl: URL, filespec: Filespec? = nil) {

        self.fileUrl = fileUrl
        self.filespec = filespec

        let fileManager = FileManager()
        fileAttributes = try? fileManager.fileAttributes(at: fileUrl)

        filespecParams = filespec?.params ?? []
        fileAttributesParams = fileAttributes?.params ?? []

        updateViews()
    }

    func updateViews() {
        guard isViewLoaded else { return }
        tableView.reloadData()
    }

}

extension FileInspectorViewController: FileInspectorTableViewDataSourceManageable {}

extension FileInspectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let numberOfRows = numberOfRowsInSection(indexPath.section)
        return numberOfRows > 0 ? UITableView.automaticDimension : .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let numberOfRows = numberOfRowsInSection(section)
        return numberOfRows > 0 ? UITableView.automaticDimension : .leastNonzeroMagnitude
    }
}

extension FileInspectorViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection(section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _sectionType = sectionType(for: indexPath.section)
        var cell: UITableViewCell? = nil
        if _sectionType == .preview {
            cell = previewCell(for: tableView, at: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            var fileParams: FileParams? = nil

            if indexPath.section == 0, isFilespecParamsAvailable {
                fileParams = filespecParams[indexPath.row]
            }

            if fileParams == nil, isfileAttributesParamsAvailable {
                fileParams = fileAttributesParams[indexPath.row]
            }

            cell?.textLabel?.text = fileParams?.name ?? ""

            cell?.detailTextLabel?.text = fileParams?.description ?? ""
        }
        return cell ?? UITableViewCell()
    }
}
