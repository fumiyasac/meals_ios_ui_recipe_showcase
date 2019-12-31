//
//  DetailTransition.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/01.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

final class DetailTransition: NSObject {

    // アニメーション対象となる画像のtag番号(遷移先のUIImageViewに付与する)
    private let customAnimatorTag = 99

    // トランジションの秒数
    private let duration: TimeInterval = 0.22

    // トランジションの方向(present: true, dismiss: false)
    var presenting: Bool = true

    // アニメーション対象なるサムネイル画像情報を格納する変数
    var originImage: UIImage? = UIImage()

    // アニメーション対象となるViewControllerの位置やサイズ情報を格納するメンバ変数
    // 1. originFrame: 画面遷移元のアニメーション対象画像Frame値
    // 2. destinationFrameは画面遷移先のアニメーション対象画像Frame値
    var originFrame: CGRect = CGRect.zero
    var destinationFrame: CGRect = CGRect.zero
}

// MARK: - UIViewControllerAnimatedTransitioning

extension DetailTransition: UIViewControllerAnimatedTransitioning {

    // アニメーションの時間を定義する
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    // アニメーションの実装を定義する
    // 画面遷移コンテキスト(UIViewControllerContextTransitioning)を利用する
    // → 遷移元や遷移先のViewControllerやそのほか関連する情報が格納されているもの
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // MEMO: UICollectionView内にContainerViewで取得している関係上ContextからUIViewControllerを取得することが難しいので、ここではView遷移先及び遷移元のView要素を取得している
        // 注意: この手法だと愚直ではあるんだけど汎用性には乏しいのが欠点...
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }

        // アニメーションの実体となるContainerViewを作成する
        let container = transitionContext.containerView

        // 表示させるViewControllerを格納するための変数を定義する
        var detailView: UIView!

        // Case1: 進む場合
        if presenting {

            container.addSubview(toView)
            detailView = toView
            
        // Case2: 戻る場合
        } else {

            container.insertSubview(toView, belowSubview: fromView)
            detailView = fromView
        }

        // 遷移先のViewControllerに配置したUIImageViewのタグ値から、カスタムトランジション時に動かすUIImageViewの情報を取得する
        // ※ 今回はDetailViewController内に配置したtransitionTargetImageViewが該当する
        guard let targetImageView = detailView.viewWithTag(customAnimatorTag) as? UIImageView else {
            return
        }
        targetImageView.image = originImage
        targetImageView.alpha = 0

        // カスタムトランジションでViewControllerを表示させるViewの表示に関する値を格納する変数
        var toViewAlpha: CGFloat!
        var beforeTransitionImageViewFrame: CGRect!
        var afterTransitionImageViewFrame: CGRect!
        var afterTransitionViewAlpha: CGFloat!

        // Case1: 進む場合
        if presenting {

            toViewAlpha = 0
            beforeTransitionImageViewFrame = originFrame
            afterTransitionImageViewFrame = destinationFrame
            afterTransitionViewAlpha = 1
            
        // Case2: 戻る場合
        } else {

            toViewAlpha = 1
            beforeTransitionImageViewFrame = destinationFrame
            afterTransitionImageViewFrame = originFrame
            afterTransitionViewAlpha = 0
        }

        // 遷移時に動かすUIImageViewを追加する
        let transitionImageView = UIImageView(frame: beforeTransitionImageViewFrame)
        transitionImageView.image = originImage
        transitionImageView.backgroundColor = UIColor(code: "#cecece")
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.clipsToBounds = true
        container.addSubview(transitionImageView)

        // 遷移先のViewのアルファ値を反映する
        toView.alpha = toViewAlpha
        toView.layoutIfNeeded()

        UIView.animate(withDuration: duration, delay: 0.00, options: [.curveEaseOut], animations: {
            transitionImageView.frame = afterTransitionImageViewFrame
            detailView.alpha = afterTransitionViewAlpha
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionImageView.removeFromSuperview()
            targetImageView.alpha = 1
        })
    }
}
