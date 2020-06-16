//
//  MainViewController.swift
//  downloader-example
//
//  Created by Sherzod Khashimov on 12/20/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var items: [(name: String, segueIdentifier: String)] = []

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        items = []
        items.append((name: "Simple Example", segueIdentifier: "\(SimpleExampleViewController.self)"))
        items.append((name: "Advanced Example", segueIdentifier: "\(AdvancedExampleViewController.self)"))
        items.append((name: "Custom URL Download Example", segueIdentifier: "\(DynamicDownloadViewController.self)"))
        items.append((name: "Image Caching Example", segueIdentifier: "\(ImagesCollectionViewController.self)"))

        self.navigationItem.title = "DMSwift"
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        self.performSegue(withIdentifier: "show\(item.segueIdentifier)", sender: nil)
    }

}
