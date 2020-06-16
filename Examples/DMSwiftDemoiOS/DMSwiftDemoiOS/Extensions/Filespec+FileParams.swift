//
//  Filespec+FileParams.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/26/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import DMSwift

extension Filespec {
    var params: [FileParams] {
        var filespecParams: [FileParams] = []
        if let url = self.url?.absoluteString {
            filespecParams.append((name: "Downloaded from", description: url))
        }
        if let name = self.name {
            filespecParams.append((name: "Name", description: name))
        }
        if let filename = self.filename {
            filespecParams.append((name: "Filename", description: filename))
        }
        if let size = self.size {
            filespecParams.append((name: "Size", description: "\(size) bytes"))
        }
        if let path = self.path {
            filespecParams.append((name: "Path", description: path))
        }
        return filespecParams
    }
}
