//
//  ArticleCategoryViewController.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/02.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class ArticleCategoryViewController: UIViewController {

    private var articleCategoryPattern: ArticleCategoryPattern!

    // MARK: - @IBOutlet
    
    @IBOutlet weak private var tableView: UITableView!

    // MARK: - Typealias

    typealias ArticleCategoryInformation = ArticleCategoryPattern

    // MARK: - Static Function (for Dependency Injection)

    static func make(with dependency: ArticleCategoryInformation) -> ArticleCategoryViewController {

        // MEMO: ViewControllerを生成する際に必要な要素をあらかじめ引き渡す
        let viewController = ArticleCategoryViewController.instantiate()
        viewController.articleCategoryPattern = dependency
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
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension ArticleCategoryViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension ArticleCategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
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
