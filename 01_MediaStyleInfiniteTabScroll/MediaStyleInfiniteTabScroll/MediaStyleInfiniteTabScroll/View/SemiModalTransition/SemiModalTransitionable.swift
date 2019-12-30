//
//  SemiModalTransitionable.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/12/30.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: セミモーダルの挙動を実現するために適用するプロトコルの定義
protocol SemiModalTransitionable where Self: UIViewController {
    var percentThreshold: CGFloat { get }
    var interactor: SemiModalTransitioningInteractor { get }
}

// MARK: - SemiModalTransitionable

extension SemiModalTransitionable {

    // MEMO: HalfModalTransitioningInteractorの状態更新におけるスワイプ速度のしきい値
    var shouldFinishVerocityY: CGFloat {
        return 1800
    }

    // MEMO: 画面遷移時のGestureの変化に応じた処理
    func handleTransitionGesture(_ sender: UIPanGestureRecognizer) {

        // 画面遷移開始時における状態変化を反映する
        switch interactor.semiModalState {
        case .shouldStart:
            interactor.semiModalState = .hasStarted
            self.dismiss(animated: true, completion: nil)
        case .hasStarted, .shouldFinish:
            break
        case .none:
            return
        }

        // 画面遷移時における変化の割合を算出する
        let translation = sender.translation(in: view)
        let verticalMovement = (translation.y - interactor.startInteractionTranslationY) / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)

        // MEMO: UIPanGestureRecognizerの変化に応じた処理を実行する
        // → SemiModalTransitioningInteractorに定義している状態を変化させることによって閉じる処理を実現する
        switch sender.state {

        // MEMO: PanGestureRecognizer実行中は、下記のいずれかの条件に合致する場合は遷移完了とする
        // (1) 動かした度合いがViewController側で設定したしきい値の割合を超えた場合
        // (2) スワイプ速度のしきい値を超えた場合
        // ※ 条件に合致しない場合は画面遷移中の扱いとする
        case .changed:
            if progress > percentThreshold || sender.velocity(in: view).y > shouldFinishVerocityY {
                interactor.semiModalState = .shouldFinish
            } else {
                interactor.semiModalState = .hasStarted
            }
            interactor.update(progress)

        // MEMO: PanGestureRecognizerキャンセル時
        // → 途中でキャンセルされてしまった場合は、セミモーダル表示状態をキャンセルし、SemiModalStateは未操作時状態へ戻す
        case .cancelled:
            interactor.cancel()
            interactor.restoreToNone()

        // MEMO: PanGestureRecognizer終了時
        // → 終了時点におけるセミモーダル表示状態に応じて表示するか否かを決定し、SemiModalStateは未操作時状態へ戻す
        case .ended:
            if interactor.semiModalState == .shouldFinish {
                interactor.finish()
            } else {
                interactor.cancel()
            }
            interactor.restoreToNone()

        default:
            break
        }

        // MEMO: 状態変化のデバッグ時に利用するログ表示
        //print("Interactor SemiModalState: \(interactor.semiModalState)")
    }
}
