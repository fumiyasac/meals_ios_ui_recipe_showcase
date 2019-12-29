//
//  SemiModalTransitioningInteractor.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/12/30.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

final class SemiModalTransitioningInteractor: UIPercentDrivenInteractiveTransition {

    // MARK: - Enum

    // セミモーダルの状態を表現するためのEnum値
    enum SemiModalState {
        case none
        case shouldStart
        case hasStarted
        case shouldFinish
    }

    // MEMO: SemiModalStateを利用してセミモーダルの振る舞うべき状態を決定している点に注意
    var semiModalState: SemiModalState = .none

    // 開始時のY軸方向の変化量を保持する変数
    var startInteractionTranslationY: CGFloat = 0

    // 開始・リセット時に一緒に実行したい処理をはさむためのクロージャー
    var startHandler: (() -> Void)?
    var resetHandler: (() -> Void)?

    // MARK: - Override

    // キャンセル処理時に実行する
    override func cancel() {

        completionSpeed = percentComplete
        super.cancel()
    }

    // 処理完了時に実行する
    override func finish() {

        completionSpeed = 1.0 - percentComplete
        super.finish()
    }

    // MARK: - Function

    // セミモーダル表示画面が開始された場合にY軸方向の変化量を更新する
    func updateValueOfStartInteractionTranslationYIfNeeded(_ translationY: CGFloat) {

        // MEMO: Interaction開始可能な際にInteraction開始までの間更新し続けることで、開始時のY軸方向の変化量を保持する
        if semiModalState == .shouldStart {
            startInteractionTranslationY = translationY
        }
    }

    // Interaction処理開始時にセミモーダルの状態を(.none → .shouldStart)へ変更をする
    func changeSemiModalStateFromNoneToShouldStartIfNeeded() {

        // MEMO: セミモーダル表示用のViewControllerでの処理がトリガーとなって状態が更新される
        if semiModalState == .none {
            semiModalState = .shouldStart
            startHandler?()
        }
    }

    // セミモーダルの状態を(任意状態 → .none)リセットする
    func restoreToNone() {
        semiModalState = .none
        startInteractionTranslationY = 0
        resetHandler?()
    }
}
