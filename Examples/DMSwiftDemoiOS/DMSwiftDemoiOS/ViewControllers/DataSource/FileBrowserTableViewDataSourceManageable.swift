//
//  FileBrowserTableViewManageable.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/26/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import UIKit

protocol FileBrowserTableViewDataSourceManageable where Self: FileBrowserViewController {}

extension FileBrowserTableViewDataSourceManageable {

    var isDirectoriesAvailable: Bool {
        return directoriesCount > 0
    }

    var isFilespecsAvailable: Bool {
        return filespecsCount > 0
    }

    var directoriesCount: Int {
        return directories?.count ?? 0
    }

    private var filespecsCount: Int {
        return filespecs?.count ?? 0
    }

    var filesCount: Int {
        if isFilespecsAvailable {
            return filespecsCount
        }
        return files?.count ?? 0
    }

    var sectionCount: Int {
        var sectionCount = 0
        sectionCount += directoriesCount > 0 ? 1 : 0
        sectionCount += filesCount > 0 ? 1 : 0
        return sectionCount
    }

    func numberOfRowInSection(_ section: Int) -> Int {
        var row = 0
        if section == 0, isDirectoriesAvailable {
            row = directoriesCount
        } else {
            row = filesCount
        }
        return row
    }

    func titleForHeaderInSection(_ section: Int) -> String {
        if section == 0, isDirectoriesAvailable {
            return "Directories"
        }
        return "Files"
    }

    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var name: String? = nil
        var imageName: String = "doc.fill"
        if indexPath.section == 0, isDirectoriesAvailable {
            let directoryName = directories?[indexPath.row].lastPathComponent
            name = directoryName
            imageName = "folder.fill"
            cell?.tag = 1
        }
        if name == nil {
            if isFilespecsAvailable {
                let filename = filespecs?[indexPath.row].filename
                name = filename
            } else {
                let filename = files?[indexPath.row].lastPathComponent
                name = filename
            }
            cell?.tag = 2
        }
        if let image = UIImage(systemName: imageName) {
            cell?.imageView?.image = image
        }
        cell?.textLabel?.text = name
        cell?.accessoryType = .disclosureIndicator
        return cell
    }
}
