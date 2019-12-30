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
        "コンテンツ一覧1",
        "コンテンツ一覧2",
        "コンテンツ一覧3",
        "コンテンツ一覧4",
        "コンテンツ一覧5",
        "コンテンツ一覧6",
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
        case "MainScrollTitleViewContainer":
            let vc = segue.destination as! MainScrollTitleViewController
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
            vc.setArticles(articles: ArticleModel.getSampleArticles())
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

        // 初期状態でのタイトル表示を反映する
        updateMainScrollTitleView(categories[0])
    }

    // 配置されているタブ表示のタイトルを更新する
    // MEMO: ContainerViewで配置しているViewControllerの親子関係を利用する
    private func updateMainScrollTitleView(_ title: String) {
        for child in children {
            if let targetViewController = child as? MainScrollTitleViewController {
                targetViewController.setTitleFromParent(title)
            }
        }
    }

    // 表示対象インデックス値に該当する画面を表示する
    // MEMO: メインスレッドで実行するようにしてクラッシュを防止する対策を施している
    private func moveToCurrentPageIndex(targetDirection: UIPageViewController.NavigationDirection) {
        DispatchQueue.main.async {
            if let targetPageViewController = self.pageViewController {
                targetPageViewController.setViewControllers([self.targetViewControllerLists[self.currentCategoryIndex]], direction: targetDirection, animated: true, completion: nil)
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

                // 受け取ったインデックス値を元にコンテンツ表示を更新する
                currentCategoryIndex = targetViewController.view.tag

                // インデックス値の変更に伴ってタイトル表示を反映する
                updateMainScrollTitleView(categories[currentCategoryIndex])
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

// MARK: - MainScrollTitleViewControllerDelegate

extension MainViewController: MainScrollTitleViewControllerDelegate {

    func moveToPrevIndex(targetDirection: UIPageViewController.NavigationDirection) {

        // MainScrollTitleViewControllerで戻るボタン押下時のインデックス値の再計算をする
        let targetIndex = currentCategoryIndex - 1
        if targetIndex < 0 {
            currentCategoryIndex = categories.count - 1
        } else {
            currentCategoryIndex = targetIndex
        }

        // インデックス値の変更に伴ってタイトル表示を反映する
        updateMainScrollTitleView(categories[currentCategoryIndex])

        // インデックス値と対応する画面を表示する
        moveToCurrentPageIndex(targetDirection: targetDirection)
    }
    
    func moveToNextIndex(targetDirection: UIPageViewController.NavigationDirection) {

        // MainScrollTitleViewControllerで進むボタン押下時のインデックス値の再計算をする
        let targetIndex = currentCategoryIndex + 1
        if targetIndex == categories.count {
            currentCategoryIndex = 0
        } else {
            currentCategoryIndex = targetIndex
        }

        // インデックス値の変更に伴ってタイトル表示を反映する
        updateMainScrollTitleView(categories[currentCategoryIndex])

        // インデックス値と対応する画面を表示する
        moveToCurrentPageIndex(targetDirection: targetDirection)
    }
}
