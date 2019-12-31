//
//  CategoryPatternCollectionViewCell.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/01.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class CategoryPatternCollectionViewCell: UICollectionViewCell {

    // MEMO: カスタムトランジション実行時にUIImageViewの情報が必要なのでinternalにする
    @IBOutlet weak var thumbnailImageView: UIImageView!

    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var cellButton: UIButton!

    var cellButtonTappedHandler: (() -> ())?

    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()

        setupCategoryPatternCollectionViewCell()
    }

    // MARK: - Function

    // MARK: - Private Function

    @objc private func cellButtonTapped(sender: UIButton) {

        // ViewController側でクロージャー内にセットした処理を実行する
        cellButtonTappedHandler?()
    }

    private func setupCategoryPatternCollectionViewCell() {

        // ボタン押下時のアクションの設定
        cellButton.addTarget(self, action:  #selector(self.cellButtonTapped(sender:)), for: .touchUpInside)
    }
}
