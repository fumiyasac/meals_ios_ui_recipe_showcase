//
//  ArticleCategoryPageItemTabView.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/02.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import Parchment

// MEMO: ライブラリ「Parchment」で提供されているPagingCellクラスを継承する
// → タブ表示用のViewクラス（今回は一部の実装においてコードで組み立てている点に注意）

class ArticleCategoryPageItemTabView: PagingCell {

    // MEMO: ライブラリ「Parchment」で提供されている見た目やデザインに関するオプション値
    // → ここでは、オプション値の定義は配置元のViewControllerにて定義しています
    private var options: PagingOptions?

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupArticleCategoryPageItemTabView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupArticleCategoryPageItemTabView()
    }

    // MARK: - Override

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = CGRect(
            x: 0,
            y: contentView.bounds.midY,
            width: contentView.bounds.width,
            height: contentView.bounds.midY
        )
        titleLabel.center = contentView.center
    }

    // タブ表示に利用するデータをタブ表示用Viewに反映する(※ PagingCellクラスにて定義)
    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {

        self.options = options
        let item = pagingItem as! ArticleCategoryPageItem
        titleLabel.text = item.type.getTabTitle()
        updateSelectedState(selected: selected)
    }

    // タブ表示用Viewのレイアウト属性値を更新する(※ PagingCellクラスにて定義)
    // → ライブラリの元を辿るとUICollectionViewを継承して作られていることがわかる
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let options = options else { return }

        // 任意のタブを移動する or 表示要素をスワイプする際に色がふわりと補間を伴った変化の演出をする
        if let attributes = layoutAttributes as? PagingCellLayoutAttributes {
            titleLabel.textColor = UIColor.interpolate(
                from: options.textColor,
                to: options.selectedTextColor,
                with: attributes.progress)
        }
    }

    // MARK: - Private Function

    private func setupArticleCategoryPageItemTabView() {
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }

    private func updateSelectedState(selected: Bool) {
        guard let options = options else { return }
        if selected {
            titleLabel.textColor = options.selectedTextColor
        } else {
            titleLabel.textColor = options.textColor
        }
    }
}
