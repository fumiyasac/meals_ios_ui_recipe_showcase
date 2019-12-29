//
//  SemiModalPresentationController.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/12/30.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: セミモーダル用のView表示を実行するための処理
// → こちらは引っ張って閉じる動作にも配慮した実装となっています。
// 参考: https://qiita.com/iincho/items/3ffc81c7de1d734cd5b4
// 参考: https://dev.classmethod.jp/references/ios8-uipresentationcontroller/

final class SemiModalPresentationController: UIPresentationController {

    // MEMO: セミモーダル表示のオーバーレイ背景となるView
    private let overlayView = UIView()

    // MARK: - Computed Property

    // セミモーダル表示対象の画面サイズをCGRect型で取得する
    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView!.bounds
    }

    // MARK: - Override

    // 遷移先への画面表示（進む画面遷移）開始時に実行する処理
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        // オーバーレイ背景となるViewに関する設定
        overlayView.frame = containerView!.bounds
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        containerView!.insertSubview(overlayView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 0.6
        })
    }

    // 遷移元への画面表示（戻る画面遷移画面遷移）開始時に実行する処理
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        // オーバーレイ背景となるViewに関する設定
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 0.0
        })
    }

    // 遷移元への画面表示（戻る画面遷移画面遷移）終了時に実行する処理
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)

        // オーバーレイ背景となるViewを画面から削除する
        if completed {
            overlayView.removeFromSuperview()
        }
    }

    // セミモーダル表示対象の画面におけるレイアウト生成が実行されるタイミングでの処理
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        // オーバーレイ背景となるViewのサイズを設定する
        overlayView.frame = containerView!.bounds
        // セミモーダル表示対象の画面サイズを設定する
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
}
