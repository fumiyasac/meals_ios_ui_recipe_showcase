//
//  CategoryPatternCollectionViewCell.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/01.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class CategoryPatternCollectionViewCell: UICollectionViewCell {

    // MARK: - @IBOutlets

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

    func setCell(_ photo: PhotoEntitiy) {

        thumbnailImageView.image = photo.imageFile
        categoryLabel.text = photo.category
        titleLabel.text = photo.title
        dateLabel.text = photo.date
    }

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
