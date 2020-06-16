//
//  FileAttributes+FileParams.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/26/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import DMSwift

extension FileAttributes {
    var params: [FileParams] {
        var fileAttributesParams: [FileParams] = []
        if let creationDate = self.creationDate {
            fileAttributesParams.append((name: "Creation date", description: creationDate.format(with: "dd.MM.yyyy")))
        }
        if let modificationDate = self.modificationDate {
            fileAttributesParams.append((name: "Modification date", description: modificationDate.format(with: "dd.MM.yyyy")))
        }
        if let readOnly = self.readOnly {
            fileAttributesParams.append((name: "Is read ony", description: String(readOnly)))
        }
        if let size = self.size {
            fileAttributesParams.append((name: "Size", description: "\(size) bytes"))
        }
        if let type = self.type {
            fileAttributesParams.append((name: "Type", description: type))
        }
        return fileAttributesParams
    }
}
