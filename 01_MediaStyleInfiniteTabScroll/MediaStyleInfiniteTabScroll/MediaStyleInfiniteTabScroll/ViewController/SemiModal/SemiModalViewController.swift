//
//  SemiModalViewController.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/11/24.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

// MEMO: InterfaceBuilderに配置したUIScrollViewにおいては「Content Layout Guide」のチェックを外す
// https://stackoverflow.com/questions/56570660/how-to-fix-scrollable-content-size-ambiguity-in-xcode-11-ios-12-ios-13-usin

// MEMO: SemiModal部分の実装は下記の記事を参考にしています
// https://qiita.com/iincho/items/3ffc81c7de1d734cd5b4

final class SemiModalViewController: UIViewController, SemiModalTransitionable {

    // MARK: - Variables

    // MEMO: HalfModalTransitionableプロトコルを適用に伴い定義する変数
    var percentThreshold: CGFloat = 0.36
    var interactor = SemiModalTransitioningInteractor()

    // MEMO: 配置したUIScrollViewのY軸方向のオフセット値を保存するための変数
    private var scrollViewContentOffsetY: CGFloat = 0.0

    // MARK: - @IBOutlets

    @IBOutlet weak private var semiModalBackgroundView: UIView!
    @IBOutlet weak private var semiModalHeaderView: UIView!
    @IBOutlet weak private var semiModalScrollView: UIScrollView!

    // MARK: - Initializer

    // MEMO: 初期化のタイミングで画面遷移に関わるtransitioningDelegateプロトコル適用とmodalPresentationStyleを実行する
    // → ViewDidLoadや外部からのDIでは発火しないのでやむなくこの形にしている
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSemiModalBackgroundView()
        setupSemiModalHeaderView()
        setupSemiModalScrollView()
    }

    // MARK: - Private Function

    @objc private func backgroundViewTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func semiModalHeaderViewDidScroll(_ sender: UIPanGestureRecognizer) {
        interactor.changeSemiModalStateFromNoneToShouldStartIfNeeded()
        handleTransitionGesture(sender)
    }

    @objc private func semiModalScrollViewDidScroll(_ sender: UIPanGestureRecognizer) {
 
        // MEMO: UIScrollViewが一番上まで到達していた場合にはセミモーダルビューのInteractorを実行する
        if scrollViewContentOffsetY <= 0.0 {
            semiModalScrollView.contentOffset.y = 0.0
            interactor.changeSemiModalStateFromNoneToShouldStartIfNeeded()
        }

        // MEMO: Interactorの実行開始位置とUIScrollViewの開始位置が異なる点に注意
        // → Interactorの実行開始のY軸方向のオフセット位置を保持する形にしている
        let translationY = sender.translation(in: view).y
        interactor.updateValueOfStartInteractionTranslationYIfNeeded(translationY)
        handleTransitionGesture(sender)
    }

    private func setupSemiModalBackgroundView() {

        // MEMO: 背景用のViewにUITapGestureRecognizerを付与する
        let backgroundViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.backgroundViewTapped))
        semiModalBackgroundView.addGestureRecognizer(backgroundViewGesture)
    }

    private func setupSemiModalHeaderView() {

       // MEMO: ヘッダー用のViewにUIPanGestureRecognizerを付与する
        let headerViewGesture = UIPanGestureRecognizer(target: self, action: #selector(self.semiModalHeaderViewDidScroll(_:)))
        semiModalHeaderView.addGestureRecognizer(headerViewGesture)
    }

    private func setupSemiModalScrollView() {

        // MEMO: コンテンツ表示用のUIScrollViewにUIPanGestureRecognizerを付与する
        // → 複数のGestureRecognizerが同時に認識できるようにする点に注意
        let scrollViewGesture = UIPanGestureRecognizer(target: self, action: #selector(self.semiModalScrollViewDidScroll(_:)))
        scrollViewGesture.delegate = self
        semiModalScrollView.addGestureRecognizer(scrollViewGesture)
        semiModalScrollView.delegate = self

        // MEMO: セミモーダル表示するUIScrollViewにおける下部のSafeAreaを考慮する
        // → iOS13以降ではsafeAreaInsetsの取得方法が変わっている点に注意
        var bottomInset: CGFloat
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            bottomInset = keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        semiModalScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
}

// MARK: - UIScrollViewDelegate

extension SemiModalViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // MEMO: UIScrollViewのY軸方向のオフセット値を保存する
        scrollViewContentOffsetY = scrollView.contentOffset.y
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SemiModalViewController: UIGestureRecognizerDelegate {

    // 複数のGestureRecognizerが存在する場合に同時認識をさせるかの判定
    // 参考: https://qiita.com/ruwatana/items/16997b1b416512c20fb6
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension SemiModalViewController: UIViewControllerTransitioningDelegate {

    // 進む場合のアニメーションの設定を行う
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SemiModalPresentationController(presentedViewController: presented, presenting: presenting)
    }

    // 戻る場合のアニメーションの設定を行う
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SemiModalDismissAnimator()
    }

    // 戻る場合のInteractionControllerに関する設定を行う
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        switch interactor.semiModalState {
        case .hasStarted, .shouldFinish:
            return interactor
        case .none, .shouldStart:
            return nil
        }
    }
}
