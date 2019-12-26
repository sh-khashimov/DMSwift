//
//  URLSessionTestable.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 11/18/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation

protocol URLSessionTestable {
    func dataTask(with request: URLRequestTestable) -> URLSessionTaskTestable
    func downloadTask(with request: URLRequestTestable) -> URLSessionTaskTestable
    func finishTasksAndInvalidate()
}

extension URLSession: URLSessionTestable {

    func dataTask(with request: URLRequestTestable) -> URLSessionTaskTestable {
        let task = dataTask(with: request as! URLRequest) as URLSessionDataTask
        return task as URLSessionTaskTestable
    }

    func downloadTask(with request: URLRequestTestable) -> URLSessionTaskTestable {
        let task = downloadTask(with: request as! URLRequest) as URLSessionDownloadTask
        return task as URLSessionTaskTestable
    }
}
