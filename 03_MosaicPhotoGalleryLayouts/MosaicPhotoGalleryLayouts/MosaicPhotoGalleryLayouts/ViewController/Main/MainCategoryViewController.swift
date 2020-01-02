//
//  MainCategoryViewController.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2019/12/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit
import Blueprints

final class MainCategoryViewController: UIViewController {

    // MARK: - Property

    // カスタムトランジションを実行するためのクラス
    private let detailTransition = DetailTransition()

    // カスタムトランジション側のクラスに引き渡す画像の情報とセルの位置情報
    private var selectedFrame: CGRect = CGRect.zero
    private var selectedImage: UIImage? = nil

    // ViewController要素を生成する際に必要な情報
    private var bluePrintPatternLayout: VerticalMosaicBlueprintLayout!

    // MARK: - @IBOutlet

    @IBOutlet weak private var collectionView: UICollectionView!

    // MARK: - Typealias

    typealias MainCategoryInformation = (title: String, layoutPattern: VerticalMosaicBlueprintLayout)

    // MARK: - Static Function (for Dependency Injection)

    static func make(with dependency: MainCategoryInformation) -> MainViewController.DisplayViewControllerSet {

        // MEMO: ViewControllerを生成する際に必要な要素をあらかじめ引き渡す
        let viewController = MainCategoryViewController.instantiate()
        viewController.bluePrintPatternLayout = dependency.layoutPattern

        // MEMO: MainViewControllerに定義したTypealiasに適合した形にする
        return (
            title: dependency.title,
            viewController: viewController
        )
    }

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }

    // MARK: - Private Function

    private func setupCollectionView() {

        // UICollectionViewに関する初期設定
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomCell(CategoryPatternCollectionViewCell.self)

        // ライブラリ「Blueprints」を活用したレイアウトパターンの適用
        collectionView.collectionViewLayout = bluePrintPatternLayout
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainCategoryViewController: UICollectionViewDelegate {}

extension MainCategoryViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: CategoryPatternCollectionViewCell.self, indexPath: indexPath)
     
        // MEMO: UICollectionViewCell内部にボタンを仕込んでおきタップ時の挙動をハンドリングする
        cell.cellButtonTappedHandler = {

            // タップしたセルよりセル内の画像と表示位置を取得する
            // MEMO: CategoryViewControllerの画面はArticleViewControllerに配置したUICollectionViewCell内に表示しているので相対位置の変換に注意
            // → CategoryViewControllerの親となるArticleViewControllerから見た場合の位置情報に換算する
            self.selectedImage = cell.thumbnailImageView.image
            self.selectedFrame = self.parent?.view.convert(cell.thumbnailImageView.frame, from: cell.thumbnailImageView.superview) ?? .zero

            let detailViewController = DetailViewController.instantiate()
            detailViewController.transitioningDelegate = self

            // MEMO: iOS13以降のPresent/Dismiss時の調整
            if #available(iOS 13.0, *) {
                detailViewController.modalPresentationStyle = .fullScreen
            }
            self.present(detailViewController, animated: true, completion: nil)
        }
        return cell
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension MainCategoryViewController: UIViewControllerTransitioningDelegate {

    // 進む場合のアニメーションの設定を行う
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        // 現在の画面サイズを引き渡してサムネイル画像が浮き上がってくる形のトランジションにする
        guard let toViewController = presented as? DetailViewController else {
            return nil
        }
        detailTransition.originImage = selectedImage
        detailTransition.originFrame = selectedFrame
        detailTransition.destinationFrame = toViewController.presentedImageFrame
        detailTransition.presenting = true
        return detailTransition
    }

    // 戻る場合のアニメーションの設定を行う
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        // 画面遷移元から画面遷移先への動きと反対方向となるトランジションにする
        guard let fromViewController = dismissed as? DetailViewController else {
            return nil
        }
        detailTransition.originImage = selectedImage
        detailTransition.originFrame = selectedFrame
        detailTransition.destinationFrame = fromViewController.dismissImageFrame
        detailTransition.presenting = false
        return detailTransition
    }
}

// MARK: - StoryboardInstantiatable

extension MainCategoryViewController: StoryboardInstantiatable {

    // このViewControllerに対応するStoryboard名
    static var storyboardName: String {
        return "MainCategory"
    }

    // このViewControllerに対応するViewControllerのIdentifier名
    static var viewControllerIdentifier: String? {
        return nil
    }
}
