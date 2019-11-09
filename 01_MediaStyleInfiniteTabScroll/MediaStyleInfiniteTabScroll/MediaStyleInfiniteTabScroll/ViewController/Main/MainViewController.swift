//
//  MainViewController.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/10/28.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Properties

    // 表示対象データ
    private let categories: [String] = [
        "安心して食べられる",
        "食べすぎ注意",
        "間食はだめよん",
        "太るよ太るよ",
        "大根スケッチの刑",
        "角砂糖イッキ",
    ]

    // 現在表示しているViewControllerのタグ番号
    private var currentCategoryIndex: Int = 0

    // ページングして表示させるViewControllerを保持する配列
    private var targetViewControllerLists: [UIViewController] = []

    // ContainerViewにEmbedしたUIPageViewControllerのインスタンスを保持する
    private var pageViewController: UIPageViewController?

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("出会った美味しいものコレクション")
        removeBackButtonText()
        setupPageViewController()
    }

    // Embed Segueに設定したIdentifierから接続されたViewControllerを取得する
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {

        // ContainerViewで接続されたViewController側に定義したプロトコルを適用する
        case "MainScrollTabViewContainer":
            let vc = segue.destination as! MainScrollTabViewController
            vc.delegate = self

        default:
            break
        }
    }

    // MARK: - Private Function

    private func setupPageViewController() {

        // UIPageViewControllerで表示させるViewControllerの一覧を配列へ格納する
        let _ = categories.enumerated().map{ (index, categoryName) in
            let sb = UIStoryboard(name: "List", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! ListViewController
            vc.view.tag = index
            targetViewControllerLists.append(vc)
        }

        // ContainerViewにEmbedしたUIPageViewControllerを取得する
        for child in children {
            if let targetPageViewController = child as? UIPageViewController {
                pageViewController = targetPageViewController
            }
        }
        
        // UIPageViewControllerDelegate & UIPageViewControllerDataSourceの宣言
        if let targetPageViewController = pageViewController {
            targetPageViewController.delegate = self
            targetPageViewController.dataSource = self
            
            // 最初に表示する画面として配列の先頭のViewControllerを設定する
            targetPageViewController.setViewControllers([targetViewControllerLists[0]], direction: .forward, animated: false, completion: nil)
        }
    }

    // 配置されているタブ表示のUICollectionViewの位置を更新する
    // MEMO: ContainerViewで配置しているViewControllerの親子関係を利用する
    private func updateMainScrollTabPosition(isIncrement: Bool) {
        for child in children {
            if let targetViewController = child as? MainScrollTabViewController {
                targetViewController.moveToMainScrollTab(isIncrement: isIncrement)
            }
        }
    }
}

// MARK: - UIPageViewControllerDelegate

extension MainViewController: UIPageViewControllerDelegate {
    
    // MEMO: ページが動いたタイミング（この場合はスワイプアニメーションに該当）に発動する処理を記載する
    // （実装例）http://c-geru.com/as_blind_side/2014/09/uipageviewcontroller.html
    // （実装例に関する解説）http://chaoruko-tech.hatenablog.com/entry/2014/05/15/103811
    // （公式ドキュメント）https://developer.apple.com/reference/uikit/uipageviewcontrollerdelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        // スワイプアニメーションが完了していない時は以降の処理は実施しない
        if !completed { return }

        // ここから先はUIPageViewControllerのスワイプアニメーション完了時に発動する
        if let targetViewControllers = pageViewController.viewControllers {
            if let targetViewController = targetViewControllers.last {

                // Case1: UIPageViewControllerで表示する画面のインデックス値が左スワイプで 0 → 最大インデックス値
                if targetViewController.view.tag - currentCategoryIndex == -categories.count + 1 {
                    updateMainScrollTabPosition(isIncrement: true)

                // Case2: UIPageViewControllerで表示する画面のインデックス値が右スワイプで 最大インデックス値 → 0
                } else if targetViewController.view.tag - currentCategoryIndex == categories.count - 1 {
                    updateMainScrollTabPosition(isIncrement: false)

                // Case3: UIPageViewControllerで表示する画面のインデックス値が +1
                } else if targetViewController.view.tag - currentCategoryIndex > 0 {
                    updateMainScrollTabPosition(isIncrement: true)

                // Case4: UIPageViewControllerで表示する画面のインデックス値が -1
                } else if targetViewController.view.tag - currentCategoryIndex < 0 {
                    updateMainScrollTabPosition(isIncrement: false)
                }

                // 受け取ったインデックス値を元にコンテンツ表示を更新する
                currentCategoryIndex = targetViewController.view.tag
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension MainViewController: UIPageViewControllerDataSource {

    // 逆方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = targetViewControllerLists.firstIndex(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
        if index <= 0 {
            return targetViewControllerLists.last
        } else {
            return targetViewControllerLists[index - 1]
        }
    }

    // 順方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = targetViewControllerLists.firstIndex(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
        if index >= targetViewControllerLists.count - 1 {
            return targetViewControllerLists.first
        } else {
            return targetViewControllerLists[index + 1]
        }
    }
}

// MARK: - MainScrollTabViewControllerDelegate

extension MainViewController: MainScrollTabViewControllerDelegate {

    // タブ側のViewControllerで選択されたインデックス値とスクロール方向を元に表示する位置を調整する
    func moveToMainContents(selectedCollectionViewIndex: Int, targetDirection: UIPageViewController.NavigationDirection, withAnimated: Bool) {

        // UIPageViewControllerに設定した画面の表示対象インデックス値を設定する
        // MEMO: タブ表示のUICollectionViewCellのインデックス値をカテゴリーの個数で割った剰余
        currentCategoryIndex = selectedCollectionViewIndex % categories.count

        // 表示対象インデックス値に該当する画面を表示する
        // MEMO: メインスレッドで実行するようにしてクラッシュを防止する対策を施している
        DispatchQueue.main.async {
            if let targetPageViewController = self.pageViewController {
                targetPageViewController.setViewControllers([self.targetViewControllerLists[self.currentCategoryIndex]], direction: targetDirection, animated: withAnimated, completion: nil)
            }
        }

    }
}
