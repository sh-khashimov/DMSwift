//
//  UIImageView+DM.swift
//  DemoiOS
//
//  Created by Sherzod Khashimov on 12/27/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import UIKit
import DMSwift

private var taskIdentifierKey: Void?

func getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

func setRetainedAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

class Box<T> {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}

class ID {
    private var arr = SynchronizedArray<String>()

    func next(for url: URL) -> Int {
        if arr.contains(url.absoluteString) {
            return current(for: url)!
        }
        arr.append(url.absoluteString)
        return arr.count-1
    }

    func current(for url: URL) -> Int? {
        return arr.index(url.absoluteString)
    }

    subscript(_ index: Int) -> String {
        return arr[index]
    }
}

fileprivate class ImageDownloadManager {

    static let shared = ImageDownloadManager()

//    static var identifer = Atomic<UInt>(0)
//    static var identifer = ID()
    static var identifer = Box<Int>(0)

    static func next() -> Int {
        ImageDownloadManager.identifer.value += 1
        return ImageDownloadManager.identifer.value
    }

    private let imageDirectoryPath = "images"

    private lazy var downloader: DMSwift = {
        let downloader = DMSwift(path: imageDirectoryPath)
        return downloader
    }()

    func download(from url: URL, completionHandler: ((_ fileLocation: URL?, _ url: URL?, _ error: Error?, _ identifer: Int) -> Void)?) {
        let identifer = ImageDownloadManager.identifer.value
        downloader.download(url, completion: { (fileLocation, url, error) in
            completionHandler?(fileLocation, url, error, identifer)
        })
    }

    func cancel(_ url: URL) {
        downloader.cancel(url)
    }

    private init() { }
}

public struct DM<Base> {
    public let base: Base
    fileprivate var taskIdentifier: Int?
    fileprivate var url: URL?
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol DMCompatible: AnyObject { }

extension DMCompatible {
    /// Gets a namespace holder for Kingfisher compatible types.
    public var dm: DM<Self> {
        get { return DM(self) }
        set { }
    }
}

extension UIImageView: DMCompatible { }

extension DM where Base: UIImageView {

    public private(set) var taskIdentifier: Int? {
        get {
            let box: Box<Int>? = getAssociatedObject(base, &taskIdentifierKey)
            return box?.value
        }
        set {
            let box = newValue.map { Box($0) }
            setRetainedAssociatedObject(base, &taskIdentifierKey, box)
        }
    }
}

extension DM where Base: UIImageView {

    func image(from url: URL) {
        var mutatingSelf = self
        mutatingSelf.url = url
        mutatingSelf.taskIdentifier = ImageDownloadManager.next()

        ImageDownloadManager.shared.download(from: url, completionHandler: { (fileLocation, imageUrl, error, identifer) in

            guard error == nil, let identifer = mutatingSelf.taskIdentifier else {
                //
                return
            }
            mutatingSelf.taskIdentifier = nil
            guard let path = fileLocation?.path,
//                self.taskIdentifier == identifer,
//                url == imageUrl,
                let image = UIImage(contentsOfFile: path) else { return }
            mutatingSelf.base.alpha = 0
            mutatingSelf.base.image = image
            UIView.animate(withDuration: 0.3) {
                mutatingSelf.base.alpha = 1
            }
        })
    }
}

// MARK: - Atomic

/// A thread-safe value wrapper.
final class Atomic<T> {
    private var _value: T
    private let lock = NSLock()

    init(_ value: T) {
        self._value = value
    }

    var value: T {
        get {
            lock.lock()
            let value = _value
            lock.unlock()
            return value
        }
        set {
            lock.lock()
            _value = newValue
            lock.unlock()
        }
    }
}

extension Atomic where T == UInt {
    /// Atomically increments the value and retruns a new incremented value.
    func increment() -> UInt {
        lock.lock()
        defer { lock.unlock() }

        _value += 1
        return _value
    }
}
