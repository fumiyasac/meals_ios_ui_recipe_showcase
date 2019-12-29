//
//  SemiModalDismissAnimator.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/12/30.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: セミモーダル表示から元の画面へ戻る場合におけるカスタムトランジションを定義する

final class SemiModalDismissAnimator: NSObject {

    // トランジションの秒数
    private let duration: TimeInterval = 0.28
}

// MARK: - UIViewControllerAnimatedTransitioning

extension SemiModalDismissAnimator: UIViewControllerAnimatedTransitioning {

    // カスタムトランジション実行時間の定義
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.28
    }

    // カスタムトランジション実行時のアニメーション処理の定義
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // TransitionContextを利用して遷移元のView要素を取得してカスタムトランジション用ContainerViewへ追加する
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)

        // アニメーション実行後のFrame値を算出する
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)

        // 画面遷移時のアニメーションを実行する
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut],
            animations: {
                fromVC.view.frame = finalFrame
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
