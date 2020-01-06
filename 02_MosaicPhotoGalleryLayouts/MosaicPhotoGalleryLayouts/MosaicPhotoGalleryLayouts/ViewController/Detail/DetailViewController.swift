//
//  DetailViewController.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2019/12/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

// MEMO: InterfaceBuilderに配置したUIScrollViewにおいては「Content Layout Guide」のチェックを外す
// https://stackoverflow.com/questions/56570660/how-to-fix-scrollable-content-size-ambiguity-in-xcode-11-ios-12-ios-13-usin

final class DetailViewController: UIViewController {

    // MARK: - Property

    // NavigationBarもどきのヘッダー部分の高さ
    private let fakeNavigationBarHeight: CGFloat = {
        var statusBarHeight: CGFloat
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        let navigationBarHeight: CGFloat = 44.0
        return statusBarHeight + navigationBarHeight
    }()

    // サムネイル画像の幅と高さ
    private let originalImageWidth: CGFloat = UIScreen.main.bounds.size.width
    private let originalImageHeight: CGFloat = UIScreen.main.bounds.size.width * 1.2

    // 下方向のスクロールを実施した際に画面を閉じる処理をするためのY軸方向のオフセット値のしきい値
    private let dismissOffsetLimit: CGFloat = -100.0

    // カスタムトランジション時に利用する、スクロール位置を考慮した戻る遷移時の矩形サイズ
    private (set)var dismissImageFrame: CGRect = CGRect.zero
    // カスタムトランジション時に利用する、遷移先の初期状態時の矩形サイズ
    private (set)var presentedImageFrame: CGRect = CGRect.zero

    // スクロールで変化する上方向のサムネイル画像の制約最大値
    private var stickyOffsetLimit: CGFloat = CGFloat.zero

    // MARK: - @IBOutlet

    // コンテンツ表示用のUIScrollView
    @IBOutlet weak private var detailScrollView: UIScrollView!

    // サムネイル画像のUIImageViewと制約値
    @IBOutlet weak private var detailImageView: UIImageView!
    @IBOutlet weak private var detailImageViewTopConstraint: NSLayoutConstraint!

    // サムネイル画像の上にかぶせているマスク用のUIViewと制約値
    @IBOutlet weak private var detailImageMaskView: UIView!
    @IBOutlet weak private var detailImageMaskViewTopConstraint: NSLayoutConstraint!

    // ダミーのNavigationBar表示をするDetailEffectiveHeaderViewと制約値
    @IBOutlet weak private var detailEffectiveHeaderView: DetailEffectiveHeaderView!
    @IBOutlet weak private var detailEffectiveHeaderHeightConstraint: NSLayoutConstraint!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupDetailImageViewAndMask()
        setupDetailEffectiveHeaderView()
        setupPresentedImageFrameForTransition()
        setupStickyOffsetLimit()
    }

    // MARK: - Private Function

    private func setupScrollView() {

        // MEMO: NavigationBar分のスクロール位置がずれてしまうのでその考慮を行う
        if #available(iOS 11.0, *) {
            detailScrollView.contentInsetAdjustmentBehavior = .never
        }
        detailScrollView.delegate = self
    }

    private func setupDetailImageViewAndMask() {
        detailImageViewTopConstraint.constant = 0
        detailImageMaskViewTopConstraint.constant = 0
        detailImageMaskView.alpha = 0
    }

    private func setupDetailEffectiveHeaderView() {

        // MEMO: ダミーのNavigationBarの相当となるエリアの高さを設定する
        // → StatusBarの高さ + NavigationBar相当の高さ = fakeNavigationBarHeight
        detailEffectiveHeaderHeightConstraint.constant = fakeNavigationBarHeight

        // MEMO: ダミーのNavigationBarの相当の初期設定
        detailEffectiveHeaderView.setTitle("食彩と風景集")
        detailEffectiveHeaderView.changeAlpha(0)
        detailEffectiveHeaderView.headerBackButtonTappedHandler = {
            self.dismissScreenDependOnVertialPosition()
        }
    }

    private func setupPresentedImageFrameForTransition() {

        presentedImageFrame = CGRect(
            x: 0,
            y: 0,
            width: originalImageWidth,
            height: originalImageHeight
        )
    }

    private func setupStickyOffsetLimit() {

        // MEMO: スクロールで変化する上方向のサムネイル画像の制約最大値を下記のように算出する
        // → 画像最大値画像の高さ - (StatusBarの高さ + NavigationBar相当の高さ = fakeNavigationBarHeight)
        stickyOffsetLimit = originalImageHeight - fakeNavigationBarHeight
    }

    // 配置したScrollViewのY軸方向のオフセット値のしきい値を超えた際に画面を閉じる
    private func dismissScreenDependOnVertialPosition() {

        // MEMO: カスタムトランジションに必要なFrame値を更新する
        dismissImageFrame = CGRect(
            x: 0,
            y: -detailScrollView.contentOffset.y,
            width: originalImageWidth,
            height: originalImageHeight
        )
        self.dismiss(animated: true, completion: nil)
    }

    // 配置したマスク用のUIViewのアルファ値を変更する
    private func changeAlphaDetailImageMaskView(_ targetAlpha: CGFloat) {
        let maxAlpha: CGFloat = 0.64
        if targetAlpha > maxAlpha {
            detailImageMaskView.alpha = maxAlpha
        } else if 0...maxAlpha ~= targetAlpha {
            detailImageMaskView.alpha = targetAlpha
        } else {
            detailImageMaskView.alpha = 0
        }
    }
}

// MARK: - UIScrollViewDelegate

extension DetailViewController: UIScrollViewDelegate {

    // スクロールが検知された時に実行される処理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let yOffset = scrollView.contentOffset.y

        // スクロールで変化する上方向のサムネイル画像の制約を更新する
        let targetConstant = -min(stickyOffsetLimit, yOffset)
        detailImageViewTopConstraint.constant = targetConstant
        detailImageMaskViewTopConstraint.constant = targetConstant

        // サムネイル画像に被せているマスク用Viewとダミータイトル表示用Viewのアルファ値を更新する
        let targetAlpha = yOffset / stickyOffsetLimit
        changeAlphaDetailImageMaskView(targetAlpha)
        detailEffectiveHeaderView.changeAlpha(targetAlpha)

        // Y軸方向のオフセット値がしきい値を超えていれば画面を閉じる
        if yOffset <= dismissOffsetLimit {
            dismissScreenDependOnVertialPosition()
        }
    }
}

// MARK: - StoryboardInstantiatable

extension DetailViewController: StoryboardInstantiatable {

    // このViewControllerに対応するStoryboard名
    static var storyboardName: String {
        return "Detail"
    }

    // このViewControllerに対応するViewControllerのIdentifier名
    static var viewControllerIdentifier: String? {
        return nil
    }
}
