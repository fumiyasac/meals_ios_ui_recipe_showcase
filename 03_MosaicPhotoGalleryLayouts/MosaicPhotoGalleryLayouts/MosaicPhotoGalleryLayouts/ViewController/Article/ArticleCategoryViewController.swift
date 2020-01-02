//
//  ArticleCategoryViewController.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/02.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class ArticleCategoryViewController: UIViewController {

    // MARK: - @IBOutlet
    
    @IBOutlet weak private var tableView: UITableView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    // MARK: - Private Function

    private func setupTableView() {

        // UITableViewに関する初期設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(ArticleListTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate

extension ArticleCategoryViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension ArticleCategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: ArticleListTableViewCell.self)
        return cell
    }
}

// MARK: - StoryboardInstantiatable

extension ArticleCategoryViewController: StoryboardInstantiatable {

    // このViewControllerに対応するStoryboard名
    static var storyboardName: String {
        return "ArticleCategory"
    }

    // このViewControllerに対応するViewControllerのIdentifier名
    static var viewControllerIdentifier: String? {
        return nil
    }
}
