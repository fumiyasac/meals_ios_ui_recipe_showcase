//
//  ArticleViewController.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/01.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit
import Parchment

final class ArticleViewController: UIViewController {

    //
    private var articleCategoryPageItemSet: [ArticleCategoryPageItem] = []

    //
    private var articleCategoryViewControllerSet: [ArticleCategoryViewController] = []

    //
    private var targetPagingViewController: PagingViewController<ArticleCategoryPageItem>!

    @IBOutlet weak private var screenView: UIView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("特選記事集サンプル")
        setupPagingViewController()
    }

    // MARK: - Private Function

    private func setupPagingViewController() {

        //
        for (_, patternType) in ArticleCategoryPattern.allCases.enumerated() {
            articleCategoryPageItemSet.append(ArticleCategoryPageItem(type: patternType, index: patternType.rawValue))
        }
        for (_, patternType) in ArticleCategoryPattern.allCases.enumerated() {
            articleCategoryViewControllerSet.append(ArticleCategoryViewController.make(with: patternType))
        }

        // MEMO: ライブラリ「Parchment」に関する見た目の調整処理
        targetPagingViewController = PagingViewController<ArticleCategoryPageItem>()
        targetPagingViewController.menuItemSource = .class(type: ArticleCategoryPageItemTabView.self)
        targetPagingViewController.menuItemSize = .fixed(width: 150, height: 44)
        targetPagingViewController.textColor = UIColor.lightGray
        targetPagingViewController.font = UIFont.systemFont(ofSize: 14)
        targetPagingViewController.selectedFont = UIFont.systemFont(ofSize: 14)
        targetPagingViewController.selectedTextColor = UIColor.black
        targetPagingViewController.indicatorColor = UIColor.black
        targetPagingViewController.indicatorOptions = .visible(height: 2, zIndex: 0, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
        targetPagingViewController.borderColor = .clear

        //
        screenView.addSubview(targetPagingViewController.view)
        targetPagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        targetPagingViewController.view.topAnchor.constraint(equalTo: screenView.topAnchor).isActive = true
        targetPagingViewController.view.leftAnchor.constraint(equalTo: screenView.leftAnchor).isActive = true
        targetPagingViewController.view.rightAnchor.constraint(equalTo: screenView.rightAnchor).isActive = true
        targetPagingViewController.view.bottomAnchor.constraint(equalTo: screenView.bottomAnchor).isActive = true

        // 表示対象のViewControllerをparentViewControllerの子として登録する
        self.addChild(targetPagingViewController)
        targetPagingViewController.didMove(toParent: self)

        // MEMO: ライブラリ「Parchment」で定義されているプロトコルの適用
        //
        targetPagingViewController.infiniteDataSource = self
        targetPagingViewController.delegate = self

        // 初期値の設定
        targetPagingViewController.reloadMenu()
        targetPagingViewController.select(pagingItem: articleCategoryPageItemSet[0])
    }
}

// MARK: - PagingViewControllerDelegate

extension ArticleViewController: PagingViewControllerDelegate {

    //
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {

        // MEMO: スワイプアニメーションが完了していない時には処理をさせなくする
        if !transitionSuccessful { return }

        // MEMO: スワイプアニメーションが完了したら表示対象のインデックス値を更新する
        let item = pagingItem as! ArticleCategoryPageItem
        targetPagingViewController.select(pagingItem: articleCategoryPageItemSet[item.index])
    }
}

// MARK: - PagingViewControllerInfiniteDataSource

extension ArticleViewController: PagingViewControllerInfiniteDataSource {

    //
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForPagingItem pagingItem: T) -> UIViewController {

        let item = pagingItem as! ArticleCategoryPageItem
        return articleCategoryViewControllerSet[item.index]
    }

    //
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemBeforePagingItem pagingItem: T) -> T? {

        // MEMO: PagingViewControllerInfiniteDataSourceを利用しているが、無限スクロールを適用しないのでこの形にする点に注意
        let item = pagingItem as! ArticleCategoryPageItem
        if let index = articleCategoryPageItemSet.firstIndex(of: item), let item = articleCategoryPageItemSet[safe: index - 1] {
            return item as? T
        } else {
            return nil
        }
    }

    //
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemAfterPagingItem pagingItem: T) -> T? {

        // MEMO: PagingViewControllerInfiniteDataSourceを利用しているが、無限スクロールを適用しないのでこの形にする点に注意
        let item = pagingItem as! ArticleCategoryPageItem
        if let index = articleCategoryPageItemSet.firstIndex(of: item), let item = articleCategoryPageItemSet[safe: index + 1] {
            return item as? T
        } else {
            return nil
        }
    }
}

// MARK: - Fileprivate Array Extension

fileprivate extension Array {

    // MARK: - Subscript
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
