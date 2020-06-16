//
//  FileInspectorTableViewManageable.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/26/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import UIKit

protocol FileInspectorTableViewDataSourceManageable where Self: FileInspectorViewController {}

extension FileInspectorTableViewDataSourceManageable {

    var isFilespecParamsAvailable: Bool {
        return filespecParams.count > 0
    }

    var isfileAttributesParamsAvailable: Bool {
        return fileAttributesParams.count > 0
    }

    var sectionCount: Int {
        return 3
    }

    func sectionType(for section: Int) -> SectionType {
        switch section {
        case 0:
            return SectionType.filespec
        case 1:
            return SectionType.fileAttribues
        default:
            break
        }
        return SectionType.preview
    }

    func titleForHeaderInSection(_ section: Int) -> String {
        guard numberOfRowsInSection(section) > 0 else { return "" }
        let _sectionType = sectionType(for: section)
        switch _sectionType {
        case .filespec:
            return "Filespec information"
        case .fileAttribues:
            return "File Attribues"
        case .preview:
            return "File Preview"
        }
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        let _sectionType = sectionType(for: section)
        switch _sectionType {
            case .filespec:
                return filespecParams.count
            case .fileAttribues:
                return fileAttributesParams.count
            case .preview:
                return 1
        }
    }

    func previewCell(for tableView: UITableView, at indexPath: IndexPath) -> FilePreviewTableViewCell? {
        let previewCell = tableView.dequeueReusableCell(withIdentifier: "\(FilePreviewTableViewCell.self)", for: indexPath) as? FilePreviewTableViewCell
        previewCell?.configure(with: fileUrl)
        return previewCell
    }
}
