//
//  MainScrollTabCollectionViewCell.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/10/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

final class MainScrollTabCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    // カテゴリー選択用セルのサイズ
    static let cellSize: CGSize = CGSize(
        width: 160.0,
        height: 48.0
    )

    // MARK: - @IBOutlets

    @IBOutlet weak private var titleLabel: UILabel!

    // MARK: - Class Function

    // カテゴリー表示用の下線の幅を算出する
    class func getMainScrollTabUnderBarWidthBy(title: String) -> CGFloat {

        // テキストの属性を設定する
        var titleAttributes: [NSAttributedString.Key : Any] = [:]
        titleAttributes[NSAttributedString.Key.font] = UIFont(
            name: "HiraMaruProN-W4",
            size: 14.0
        )

        // 引数で渡された文字列とフォントから配置するラベルの幅を取得する
        let titleLabelSize = CGSize(
            width: .greatestFiniteMagnitude,
            height: 14.0
        )
        let titleLabelRect = title.boundingRect(
            with: titleLabelSize,
            options: .usesLineFragmentOrigin,
            attributes: titleAttributes,
            context: nil
        )

        // 配置されているラベルのRect値からwidthを利用する
        return ceil(titleLabelRect.width)
    }

    // MARK: - Function

    // タブ表示用のセルに表示する内容を設定する
    func setTitle(name: String, isSelected: Bool = false) {
        titleLabel.text = name
        titleLabel.textColor = isSelected ? UIColor(code: "#ff6060") : UIColor.label
    }
}
