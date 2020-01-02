//
//  ArticleListTableViewCell.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/02.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class ArticleListTableViewCell: UITableViewCell {

    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()

        setupArticleListTableViewCell()
    }

    // MARK: - Function

    // MARK: - Private Function

    private func setupArticleListTableViewCell() {

        // UITableViewCellに関するそれ自体に関する設定
        self.accessoryType = .none
        self.selectionStyle = .none
    }
}
