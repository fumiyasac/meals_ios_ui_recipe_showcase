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

    // MEMO: ライブラリ「Parchment」におけるタブ要素データを格納する配列
    private var articleCategoryPageItemSet: [ArticleCategoryPageItem] = []

    // MEMO: ライブラリ「Parchment」におけるタブ要素で表示する画面を格納する配列
    private var articleCategoryViewControllerSet: [ArticleCategoryViewController] = []

    // MEMO: ライブラリ「Parchment」におけるタブ要素で表示対象の画面を格納する
    private var targetPagingViewController: PagingViewController!

    @IBOutlet weak private var screenView: UIView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("特選記事集サンプル")
        setupPagingViewController()
    }

    // MARK: - Private Function

    private func setupPagingViewController() {

        // タブ要素データとタブ要素で表示する画面を組み立てる
        for (_, patternType) in ArticleCategoryPattern.allCases.enumerated() {
            articleCategoryPageItemSet.append(ArticleCategoryPageItem(type: patternType, index: patternType.rawValue))
        }
        for _ in ArticleCategoryPattern.allCases {
            articleCategoryViewControllerSet.append(ArticleCategoryViewController.make())
        }

        // MEMO: ライブラリ「Parchment」における見た目(PagingOptions)の調整処理
        targetPagingViewController = PagingViewController()
        targetPagingViewController.register(ArticleCategoryPageItemTabView.self, for: ArticleCategoryPageItem.self)
        targetPagingViewController.menuItemSize = .fixed(width: 150, height: 44)
        targetPagingViewController.font = UIFont(name: "HiraKakuProN-W3", size: 12.0)!
        targetPagingViewController.selectedFont = UIFont(name: "HiraKakuProN-W3", size: 12.0)!
        targetPagingViewController.textColor = UIColor.lightGray
        targetPagingViewController.selectedTextColor = UIColor.black
        targetPagingViewController.indicatorColor = UIColor.black
        targetPagingViewController.borderColor = UIColor(code: "#dddddd")
        targetPagingViewController.indicatorOptions = .visible(height: 2, zIndex: 0, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)

        // MEMO: ライブラリ「Parchment」で定義されているプロトコルの適用
        // → コードでのAutoLayoutを利用してスクリーンとなるView要素の中に配置する
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
        // → UIPageViewControllerのものと似ているがこれはライブラリで提供されているもの
        targetPagingViewController.infiniteDataSource = self
        targetPagingViewController.delegate = self

        // 初期表示状態の設定
        targetPagingViewController.reloadMenu()
        targetPagingViewController.select(pagingItem: articleCategoryPageItemSet[0])
    }
}

// MARK: - PagingViewControllerDelegate

extension ArticleViewController: PagingViewControllerDelegate {

    // 表示要素を切り替えるトランジションの完了状態を検知するための処理
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {

        // MEMO: スワイプアニメーションが完了していない時には処理をさせなくする
        if !transitionSuccessful { return }

        // MEMO: スワイプアニメーションが完了したら表示対象のインデックス値を更新する
        if let targetItem = pagingItem as? ArticleCategoryPageItem {
            targetPagingViewController.select(pagingItem: articleCategoryPageItemSet[targetItem.index])
        }
    }
}

// MARK: - PagingViewControllerInfiniteDataSource

extension ArticleViewController: PagingViewControllerInfiniteDataSource {

    // タブ要素データ内のインデックス値に該当する画面を表示するための処理
    func pagingViewController(_: PagingViewController, viewControllerFor pagingItem: PagingItem) -> UIViewController {
        let item = pagingItem as! ArticleCategoryPageItem
        return articleCategoryViewControllerSet[item.index]

    }

    // ページ要素を移動した際にタブ要素データ内のインデックス値が+1増加する場合における処理
    func pagingViewController(_ : PagingViewController, itemAfter pagingItem: PagingItem) -> PagingItem? {

        // MEMO: PagingViewControllerInfiniteDataSourceを利用しているが、無限スクロールを適用しないのでこの形にする点に注意
        if let item = pagingItem as? ArticleCategoryPageItem,
           let index = articleCategoryPageItemSet.firstIndex(of: item),
           let targetItem = articleCategoryPageItemSet[safe: index + 1] {
            return targetItem
        } else {
            return nil
        }
    }

    // ページ要素を移動した際にタブ要素データ内のインデックス値が-1減少する場合における処理
    func pagingViewController(_: PagingViewController, itemBefore pagingItem: PagingItem) -> PagingItem? {

        // MEMO: PagingViewControllerInfiniteDataSourceを利用しているが、無限スクロールを適用しないのでこの形にする点に注意
        if let item = pagingItem as? ArticleCategoryPageItem,
           let index = articleCategoryPageItemSet.firstIndex(of: item),
           let targetItem = articleCategoryPageItemSet[safe: index - 1] {
            return targetItem
        } else {
            return nil
        }
    }
}

// MARK: - Fileprivate Array Extension

// MEMO: このファイル内のみで利用できるExtensionの定義
fileprivate extension Array {

    // MARK: - Subscript

    subscript (safe index: Index) -> Element? {

        // MEMO: 任意の配列要素に含まれないインデックスを指定した場合にnilを返すようにする
        // ※ 配列での「index out of range」を少しでも防止するために用いる
        return indices.contains(index) ? self[index] : nil
    }
}
