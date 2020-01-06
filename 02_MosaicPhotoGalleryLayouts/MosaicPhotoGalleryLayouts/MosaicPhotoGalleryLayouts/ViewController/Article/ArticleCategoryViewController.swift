//
//  ArticleCategoryViewController.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/02.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class ArticleCategoryViewController: UIViewController {

    // MARK: - Property

    private var articles: [ArticleEntity] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var articleCategoryPattern: ArticleCategoryPattern!

    // MARK: - @IBOutlet
    
    @IBOutlet weak private var tableView: UITableView!

    // MARK: - Static Function (for Dependency Injection)

    static func make() -> ArticleCategoryViewController {

        let viewController = ArticleCategoryViewController.instantiate()
        return viewController
    }

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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCustomCell(ArticleListTableViewCell.self)

        // 表示データの反映
        articles = ArticleModel.getSampleArticles()
    }
}

// MARK: - UITableViewDelegate

extension ArticleCategoryViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension ArticleCategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCustomCell(with: ArticleListTableViewCell.self)
        cell.setCell(articles[indexPath.row])
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
