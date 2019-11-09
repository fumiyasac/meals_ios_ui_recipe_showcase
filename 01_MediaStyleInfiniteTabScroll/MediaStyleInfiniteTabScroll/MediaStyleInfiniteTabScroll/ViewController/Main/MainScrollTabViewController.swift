//
//  MainScrollTabViewController.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/10/29.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

// カテゴリタブ一覧タブ操作時に実行されるプロトコル
protocol MainScrollTabViewControllerDelegate: NSObjectProtocol {

    // UIPageViewControllerで表示しているインデックスの画面へ遷移する
    func moveToMainContents(selectedCollectionViewIndex: Int, targetDirection: UIPageViewController.NavigationDirection, withAnimated: Bool)
}

final class MainScrollTabViewController: UIViewController {

    // MARK: - Protocol Variables

    weak var delegate: MainScrollTabViewControllerDelegate?

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

    // ボタン押下時の軽微な振動を追加する
    private let buttonFeedbackGenerator: UIImpactFeedbackGenerator = {
        let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()

    // MEMO: UICollectionViewの一番最初のセル表示位置に関する設定
    // 参考: https://www.101010.fun/entry/swift-once-exec
    private lazy var setInitialScrollTabPosition: (() -> ())? = {

        // 押下した場所のインデックス値を持っておくために、実際のタブ個数の2倍の値を設定する
        currentSelectIndex = self.categories.count * 2
        //print("初期表示時の中央インデックス値:", currentSelectIndex)

        // 変数(currentSelectIndex)を基準にして位置情報を更新する
        updateMainScrollTabCollectionViewPosition(withAnimated: false)
        return nil
    }()

    // 配置したセル幅の合計値
    private var allTabViewTotalWidth: CGFloat = 0.0

    // 現在選択中のインデックス値を格納する変数(このクラスに配置しているUICollectionViewのIndex番号)
    private var currentSelectIndex = 0

    // MARK: - @IBOutlets

    @IBOutlet weak private var mainScrollTabCollectionView: UICollectionView!
    @IBOutlet weak private var selectedUnderlineWidth: NSLayoutConstraint!

    // MARK: - Computed Properties

    // MEMO:
    // ここでは無限スクロールができるように予め、(実際の個数 × 4)のセルを配置している
    // またscrollViewDidScroll内の処理で所定の位置で調整をかけるので実際のUICollectionViewCellのインデックス値の範囲は下記のようになる
    // 例. タブを6個設定する場合 → 6 ... 19が取り得る範囲となる

    // 表示するカテゴリーの個数を元にしたインデックスの最大値
    // 例. カテゴリーが6個の場合は5となる
    private var targetContentsMaxIndex: Int {
        return categories.count - 1
    }

    // 実際に配置したUICollectionViewCellが取り得るインデックスの最大値
    // 例. カテゴリーが6個の場合は19となる
    private var targetCollectionViewCellMaxIndex: Int {
        return categories.count * 4 - targetContentsMaxIndex
    }

    // 実際に配置したUICollectionViewCellが取り得るインデックスの最小値
    // 例. カテゴリーが6個の場合は6となる
    private var targetCollectionViewCellMinIndex: Int {
        return categories.count
    }
    
    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainScrollTabCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // MEMO: この部分は一番最初に起動した時だけ発火するようにする
        setInitialScrollTabPosition?()
    }

    // MARK: - Function

    // 親(MainViewController)のUIPageViewControllerのスクロール方向を元にUICollectionViewの位置を設定する
    // MEMO: このメソッドはUIPageViewControllerを配置している親(ArticleViewController)から実行される
    func moveToMainScrollTab(isIncrement: Bool = true) {

        // UIPageViewControllerのスワイプ方向を元に、更新するインデックスの値を設定する
        var targetIndex = isIncrement ? currentSelectIndex + 1 : currentSelectIndex - 1

        // 取りうるべきインデックスの値が閾値(targetCollectionViewCellMaxIndex)を超えた場合は補正をする
        if targetIndex > targetCollectionViewCellMaxIndex {
            targetIndex = targetCollectionViewCellMaxIndex - targetContentsMaxIndex
            currentSelectIndex = targetCollectionViewCellMaxIndex
        }

        // 取りうるべきインデックスの値が閾値(targetCollectionViewCellMinIndex)を下回った場合は補正をする
        if targetIndex < targetCollectionViewCellMinIndex {
            targetIndex = targetCollectionViewCellMinIndex + targetContentsMaxIndex
            currentSelectIndex = targetCollectionViewCellMinIndex
        }

        // MEMO: タブがスクロールされている状態でUIPageViewControllerがスワイプされた場合の考慮
        // → スクロール中である場合には強制的に慣性スクロールを停止させる
        let isScrolling = (mainScrollTabCollectionView.isDragging || mainScrollTabCollectionView.isDecelerating)
        if isScrolling {
            mainScrollTabCollectionView.setContentOffset(mainScrollTabCollectionView.contentOffset, animated: true)
        }

        // 押下した場所のインデックス値を持っておく
        currentSelectIndex = targetIndex
        //print("コンテンツ表示側のインデックスを元にした現在のインデックス値:", currentSelectIndex)

        // 変数(currentSelectIndex)を基準にして位置情報を更新する
        updateMainScrollTabCollectionViewPosition(withAnimated: true)

        // 「コツッ」とした感じの端末フィードバックを発火する
        buttonFeedbackGenerator.impactOccurred()
    }

    // MARK: - Private Function

    // UICollectionViewに関する設定
    private func setupMainScrollTabCollectionView() {

        mainScrollTabCollectionView.delegate = self
        mainScrollTabCollectionView.dataSource = self
        mainScrollTabCollectionView.registerCustomCell(MainScrollTabCollectionViewCell.self)

        // MEMO: タブ内のスクロール移動を許可する場合はtrueにし、許可しない場合はfalseとする
        // 注意: trueにした際にはタブ表示部分をスクロール中にUIPageViewControllerをスワイプする際のクラッシュ回避が必要です
        mainScrollTabCollectionView.isScrollEnabled = true //false

        // MEMO: 水平方向のスクロールインジケーターを非表示にする
        mainScrollTabCollectionView.showsHorizontalScrollIndicator = false

        // MEMO: このサンプルでInterfaceBuilderで設定しているもの
        // - 1. レイアウト属性 → 独自に定義した「MainScrollTabCollectionViewFlowLayoutクラス」を「Collection View Flow Layout」の部分に適用する
        // - 2. セルのサイズ指定 →「Estimate Size」の部分に「None」を適用する
    }

    // 選択もしくはスクロールが止まるであろう位置にあるセルのインデックス値を元にUICollectionViewの位置を更新する
    private func updateMainScrollTabCollectionViewPosition(withAnimated: Bool = false) {

        // インデックス値に相当するタブを真ん中に表示させる
        let targetIndexPath = IndexPath(row: currentSelectIndex, section: 0)
        mainScrollTabCollectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: withAnimated)

        // UICollectionViewの下線の長さを設定する
        let categoryListIndex = currentSelectIndex % categories.count
        setUnderlineWidthFrom(categoryTitle: categories[categoryListIndex])

        // 現在選択されている位置に色を付けるためにCollectionViewをリロードする
        mainScrollTabCollectionView.reloadData()
    }

    // スクロールするタブの下にある下線の幅を文字の長さに合わせて設定する
    private func setUnderlineWidthFrom(categoryTitle: String) {

        // 下線用のViewに付与したAutoLayoutの幅に関する制約値を更新する
        let targetWidth = MainScrollTabCollectionViewCell.getMainScrollTabUnderBarWidthBy(title: categoryTitle)
        selectedUnderlineWidth.constant = targetWidth
        UIView.animate(withDuration: 0.36, animations: {
            self.view.layoutIfNeeded()
        })
    }

    // UIPageViewControllerを動かす方向を受け取ったインデックス値(indexPath.row)と現在のインデックス値(currentSelectIndex)を元に算出する
    // MEMO: 親(MainViewController)のUIPageViewCotrollerの更新はCategoryScrollTabDelegateのメソッドを経由して実行する
    private func getMainContentsNavigationDirection(selectedIndex: Int) -> UIPageViewController.NavigationDirection {
        
        // 下記の条件を満たす場合は例外的に進む方向とする
        // 1. 引数で渡されたインデックス値:
        //   - selectedIndex が (targetCollectionViewCellMaxIndex - targetContentsMaxIndex) と等しい
        // 2. 現在のインデックス値:
        //   - currentSelectIndex が targetCollectionViewCellMaxIndex と等しい
        if selectedIndex == targetCollectionViewCellMaxIndex - targetContentsMaxIndex && currentSelectIndex == targetCollectionViewCellMaxIndex {
            return UIPageViewController.NavigationDirection.forward
        }

        // 下記の条件を満たす場合は例外的に戻す方向とする
        // 1. 引数で渡されたインデックス値:
        //   - selectedIndex が (targetCollectionViewCellMinIndex + targetContentsMaxIndex) と等しい
        // 2. 現在のインデックス値:
        //   - currentSelectIndex が targetCollectionViewCellMinIndex と等しい
        if selectedIndex == targetCollectionViewCellMinIndex + targetContentsMaxIndex && currentSelectIndex == targetCollectionViewCellMinIndex {
            return UIPageViewController.NavigationDirection.reverse
        }

        // (現在のインデックス値 - 引数で渡されたインデックス値)を元に方向を算出する
        if currentSelectIndex - selectedIndex > 0 {
            return UIPageViewController.NavigationDirection.reverse
        } else {
            return UIPageViewController.NavigationDirection.forward
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainScrollTabViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension MainScrollTabViewController: UICollectionViewDataSource {

    // 配置するセルの個数を設定する
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // MEMO: 無限スクロールの対象とする場合はタブ表示要素の4倍余分に要素を表示する
        return categories.count * 4
    }

    // 配置するセルの表示内容を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: MainScrollTabCollectionViewCell.self, indexPath: indexPath)
        let targetIndex = indexPath.row % categories.count
        let isSelectedTab = (indexPath.row % categories.count == currentSelectIndex % categories.count)
        cell.setTitle(name: categories[targetIndex], isSelected: isSelectedTab)
        return cell
    }

    // セル押下時の処理内容を記載する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // UIPageViewControllerを動かす方向を選択したインデックス値(indexPath.row)と現在のインデックス値(currentSelectIndex)を元に算出する
        let targetDirection = getMainContentsNavigationDirection(selectedIndex: indexPath.row)

        // 押下した場所のインデックス値を現在のインデックス値を格納している変数(currentSelectIndex)にセットする
        currentSelectIndex = indexPath.row
        //print("タブ押下時の中央インデックス値:", currentSelectIndex)

        // 変数(currentSelectIndex)を基準にして位置情報を更新する
        updateMainScrollTabCollectionViewPosition(withAnimated: true)

        // 算出した現在のインデックス値・動かす方向の値を元に、UIPageViewControllerで表示しているインデックスの画面へ遷移する
        self.delegate?.moveToMainContents(
            selectedCollectionViewIndex: currentSelectIndex,
            targetDirection: targetDirection,
            withAnimated: true
        )

        // 「コツッ」とした感じの端末フィードバックを発火する
        buttonFeedbackGenerator.impactOccurred()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainScrollTabViewController: UICollectionViewDelegateFlowLayout {
    
    // タブ用のセルにおける矩形サイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return MainScrollTabCollectionViewCell.cellSize
    }

    // セルの垂直方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    // セルの水平方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    // セル内のアイテム間の余白(margin)調整を行う
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

// MARK: - UIScrollViewDelegate

extension MainScrollTabViewController: UIScrollViewDelegate {

    // 配置したUICollectionViewをスクロールしている際に実行される処理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // 表示したいセル要素のWidthを計算する
        // MEMO: 実際の幅の値が欲しいのでUIScrollView内の幅を1/4したものになる
        if allTabViewTotalWidth == 0.0 {
            allTabViewTotalWidth = floor(scrollView.contentSize.width / 4.0)
        }

        // スクロールした位置が閾値を超えたら中央に戻す
        if (scrollView.contentOffset.x <= allTabViewTotalWidth) || (scrollView.contentOffset.x > allTabViewTotalWidth * 3.0) {
            scrollView.contentOffset.x = allTabViewTotalWidth * 2.0
        }
    }

    // 配置したUICollectionViewをスクロールが止まった際に実行される処理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // スクロールが停止した際に見えているセルのインデックス値を格納して、真ん中にあるものを取得する
        // 参考: https://stackoverflow.com/questions/18649920/uicollectionview-current-visible-cell-index

        var visibleIndexPathList: [IndexPath] = []
        for cell in mainScrollTabCollectionView.visibleCells {
            if let visibleIndexPath = mainScrollTabCollectionView.indexPath(for: cell) {
                visibleIndexPathList.append(visibleIndexPath)
                //print("現在画面内に見えているセルのインデックス値:", visibleIndexPath)
            }
        }
        let targetIndexPath = visibleIndexPathList[1]

        // ※この部分は厳密には不要ではあるがdelegeteで引き渡す必要があるので設定している
        let targetDirection = getMainContentsNavigationDirection(selectedIndex: targetIndexPath.row)

        // 押下した場所のインデックス値を現在のインデックス値を格納している変数(currentSelectIndex)にセットする
        currentSelectIndex = targetIndexPath.row
        //print("スクロールが慣性で停止した時の中央インデックス値:", currentSelectIndex)

        // 変数(currentSelectIndex)を基準にして位置情報を更新する
        updateMainScrollTabCollectionViewPosition(withAnimated: true)

        // 算出した現在のインデックス値・動かす方向の値を元に、UIPageViewControllerで表示しているインデックスの画面へ遷移する
        self.delegate?.moveToMainContents(
            selectedCollectionViewIndex: currentSelectIndex,
            targetDirection: targetDirection,
            withAnimated: false
        )

        // 「コツッ」とした感じの端末フィードバックを発火する
        buttonFeedbackGenerator.impactOccurred()
    }
}
