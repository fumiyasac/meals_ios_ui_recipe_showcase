//
//  RecommendCollectionViewCell.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/06.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit
import Nuke

final class RecommendCollectionViewCell: UICollectionViewCell {

    // MARK: - @IBOutlet

    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!

    // MARK: - Function

    func setCell(_ recommend: Recommend) {

        // MEMO: Nukeでの画像キャッシュと表示に関するオプション設定
        let imageDisplayOptions = ImageLoadingOptions(transition: .fadeIn(duration: 0.33))
        if let imageUrl = URL(string: recommend.imageUrl) {
            Nuke.loadImage(with: imageUrl, options: imageDisplayOptions, into: thumbnailImageView)
        }

        categoryLabel.text = recommend.category
        titleLabel.text = recommend.title
    }
}
