//
//  DetailSwitchButtonsView.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/11/22.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// コンテンツ切り替えボタン押下時に実行されるプロトコル
protocol DetailSwitchButtonsViewDelegate: NSObjectProtocol {

    // DetailViewControllerに配置したUIScrollViewを水平方向にアニメーションさせる際に利用する
    func moveDetailScrollViewHorizontally(selectedButtonTag: Int)
}

final class DetailSwitchButtonsView: CustomViewBase {

    // MARK: - Protocol Variables

    weak var delegate: DetailSwitchButtonsViewDelegate?

    // MARK: - Properties

    // 現在位置とそうでない場合の状態におけるボタンの配色
    private let buttonNormalColor = UIColor.init(code: "#aaaaaa")
    private let buttonSelectedColor = UIColor.init(code: "#ff6060")

    // MARK: - @IBOutlets

    // スライドする下線表示用のViewにおける左側の制約（※初期値は0）
    @IBOutlet weak private var selectedBarLeftConstraint: NSLayoutConstraint!

    // 詳細表示とコメント表示を切り替えるためのボタン
    @IBOutlet weak private var switchInformationButton: UIButton!
    @IBOutlet weak private var switchCommentButton: UIButton!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupDetailSwitchButtonsView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupDetailSwitchButtonsView()
    }

    // MARK: - Function

    // ViewController側に配置したUIScrollViewのX軸方向のオフセット値と連動した処理を実行する
    func updateSelectedBarPositionBy(scrollViewOffsetX: CGFloat) {

        // MEMO: (下線表示用のViewの左方向の余白) = (UIScrollViewにおけるcontentOffset.x) / 2
        let selectedBarPositionX = scrollViewOffsetX / 2
        selectedBarLeftConstraint.constant = selectedBarPositionX

        // MEMO: (ボタン状態を決定するためのタグ値) = round((UIScrollViewにおけるcontentOffset.x) / (画面全体幅))
        let selectedBarPositionByTag = Int(round(scrollViewOffsetX / UIScreen.main.bounds.width))
        changeButtonsColorBy(tag: selectedBarPositionByTag)
    }

    // MARK: - Private Function

    // このViewに配置しているボタンを押下した際に実行される処理
    @objc private func handleButtonTapped(sender: UIButton) {

        // 下線表示用のView位置の変更とボタン配色の変更を設定したタグ値を元に設定する
        changeButtonsColorBy(tag: sender.tag)
        animateSelectedBarPositionBy(tag: sender.tag)

        // DetailViewControllerに定義したUIScrollViewに対して水平方向のアニメーションを実行する
        self.delegate?.moveDetailScrollViewHorizontally(selectedButtonTag: sender.tag)
    }

    // 下線表示用のViewに対して位置変更のアニメーションを実行する
    private func animateSelectedBarPositionBy(tag: Int) {

        // MEMO: 下線表示用のViewを動かす位置をボタンに設定したタグ値を利用して計算する
        selectedBarLeftConstraint.constant = UIScreen.main.bounds.width / 2 * CGFloat(tag)
        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseInOut], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }

    // ボタン配色の変更を引数で受け取ったタグ値を元に設定する
    private func changeButtonsColorBy(tag: Int) {

        if tag == 0 {
            switchInformationButton.setTitleColor(buttonSelectedColor, for: .normal)
            switchCommentButton.setTitleColor(buttonNormalColor, for: .normal)
        } else {
            switchInformationButton.setTitleColor(buttonNormalColor, for: .normal)
            switchCommentButton.setTitleColor(buttonSelectedColor, for: .normal)
        }
    }

    // DetailSwitchButtonsViewの初期設定
    private func setupDetailSwitchButtonsView() {

        switchInformationButton.tag = 0
        switchInformationButton.setTitleColor(buttonSelectedColor, for: .normal)
        switchInformationButton.addTarget(self, action:  #selector(self.handleButtonTapped(sender:)), for: .touchUpInside)

        switchCommentButton.tag = 1
        switchCommentButton.setTitleColor(buttonNormalColor, for: .normal)
        switchCommentButton.addTarget(self, action:  #selector(self.handleButtonTapped(sender:)), for: .touchUpInside)
    }
}
