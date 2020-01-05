//
//  MainViewController.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2019/12/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class MainViewController: UIViewController {

    // MARK: - Property

    // MARK: - Enum

    private enum ContainerViewIndex: Int {
        case photo
        case search
    }

    // MARK: - @IBOutlet

    @IBOutlet weak private var screenView: UIView!
    @IBOutlet weak private var photoContainerView: UIView!
    @IBOutlet weak private var searchContainerView: UIView!
    @IBOutlet weak private var screenSegmentControl: BetterSegmentedControl!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("城下町金沢の風景")
        setupScreenSegmentControl()
        setupScreenContainerViews()
    }

    // MARK: - Private Function
    
    @objc private func controlValueChanged(sender: BetterSegmentedControl) {
        changeScreenBySelectedIndex(sender.index)
    }
    
    private func setupScreenSegmentControl() {

        // BetterSegmentedControlのデザインに関する設定
        screenSegmentControl.backgroundColor = UIColor.white
        screenSegmentControl.layer.borderColor = UIColor(code: "#00a6ff").cgColor
        screenSegmentControl.layer.borderWidth = 1.0
        screenSegmentControl.indicatorViewBackgroundColor = UIColor(code: "#00a6ff")
        screenSegmentControl.cornerRadius = 25.0

        // MEMO: アニメーション秒数とばねの減衰比を設定する
        screenSegmentControl.animationDuration = 0.26
        screenSegmentControl.animationSpringDamping = 0.66

        // BetterSegmentedControlの表示やアクションに関する設定
        screenSegmentControl.segments = LabelSegment.segments(
            withTitles: ["写真一覧表示", "キーワード検索"],
            normalFont: UIFont(name: "Avenir-Heavy", size: 13.0)!,
            normalTextColor: UIColor(code: "#00a6ff"),
            selectedFont: UIFont(name: "Avenir-Heavy", size: 13.0)!,
            selectedTextColor: UIColor.white
        )
        screenSegmentControl.addTarget(self, action: #selector(self.controlValueChanged(sender:)), for: .valueChanged)
    }

    private func setupScreenContainerViews() {

        // コンテンツ表示用のContainerViewの初期表示状態の設定
        photoContainerView.alpha = 1
        searchContainerView.alpha = 0
    }

    private func changeScreenBySelectedIndex(_ index: Int) {

        let shouldDisplayPhoto = (index == 0)
        UIView.animate(withDuration: 0.24, animations: {
            
            // コンテンツ表示用のContainerViewのアルファ値を変更する
            if shouldDisplayPhoto {
                self.photoContainerView.alpha = 1
                self.searchContainerView.alpha = 0
            } else {
                self.photoContainerView.alpha = 0
                self.searchContainerView.alpha = 1
            }

        }, completion: { _ in

            // コンテンツ表示用のContainerViewの表示順番を入れ替える
            if shouldDisplayPhoto {
                self.screenView.bringSubviewToFront(self.photoContainerView)
            } else {
                self.screenView.bringSubviewToFront(self.searchContainerView)
            }
        })
    }
}
