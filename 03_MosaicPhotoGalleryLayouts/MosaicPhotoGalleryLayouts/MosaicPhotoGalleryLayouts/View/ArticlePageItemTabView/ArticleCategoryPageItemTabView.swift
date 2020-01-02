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

//

class ArticleCategoryPageItemTabView: PagingCell {

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

    //
    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        self.options = options
        let item = pagingItem as! ArticleCategoryPageItem
        titleLabel.text = item.type.getTabTitle()
        updateSelectedState(selected: selected)
    }

    //
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let options = options else { return }

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
