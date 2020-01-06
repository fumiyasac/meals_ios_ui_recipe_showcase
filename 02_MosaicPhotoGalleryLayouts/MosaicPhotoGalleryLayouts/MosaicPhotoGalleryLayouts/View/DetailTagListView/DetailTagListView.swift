//
//  DetailTagListView.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/03.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import TagListView

final class DetailTagListView: CustomViewBase {

    private let detailTags: [String] = [
        "UI実装", "UIサンプル", "UI構築例", "iOS", "AutoLayout", "CocoaPods",
        "行きつけのお店", "おしゃれなカフェ", "ランチメニュー", "パスタ", "スパゲッティ", "トマトソース",
        "和風パスタ", "クリームパスタ", "イタリアン"
    ]
    
    @IBOutlet weak private var detailTagListView: TagListView!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupDetailTagListView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupDetailTagListView()
    }

    // MARK: - Private Function

    private func setupDetailTagListView() {

        // MEMO: ライブラリ「TagListView」を利用したタグクラウドの様な実現する処理

        // タグ表示をするViewに関するデザインやオプション等の設定
        detailTagListView.delegate = self
        detailTagListView.textFont = UIFont(name: "Avenir-Heavy", size: 13.0)!
        detailTagListView.cornerRadius = 6.0
        detailTagListView.tagBackgroundColor = UIColor(code: "#ff9900")
        detailTagListView.paddingX = 8.0
        detailTagListView.paddingY = 8.0
        detailTagListView.marginX = 10.0
        detailTagListView.marginY = 18.0
        detailTagListView.backgroundColor = UIColor.clear
        detailTagListView.alignment = .left

        // タグ表示をする要素を追加する
        detailTagListView.addTags(detailTags)
    }
}

// MARK: - TagListViewDelegate

extension DetailTagListView: TagListViewDelegate {

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("表示タグ名: \(title)が押下されました！")
    }
}
