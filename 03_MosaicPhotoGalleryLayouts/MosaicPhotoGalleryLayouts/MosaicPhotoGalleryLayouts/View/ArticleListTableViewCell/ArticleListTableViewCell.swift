//
//  ArticleListTableViewCell.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/02.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class ArticleListTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var summaryLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var remarkLabel: UILabel!
    
    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()

        setupArticleListTableViewCell()
    }

    // MARK: - Function

    func setCell(_ article: ArticleEntity) {

        let titleKeys = (
            lineSpacing: CGFloat(5),
            font: UIFont(name: "Avenir-Heavy", size: 13.0)!,
            foregroundColor: UIColor.black
        )
        let titleAttributes = UILabelDecorator.getLabelAttributesBy(keys: titleKeys)
        titleLabel.attributedText = NSAttributedString(string: article.title, attributes: titleAttributes)

        let summaryKeys = (
            lineSpacing: CGFloat(4),
            font: UIFont(name: "Avenir-Book", size: 12.0)!,
            foregroundColor: UIColor.darkGray
        )
        let summaryAttributes = UILabelDecorator.getLabelAttributesBy(keys: summaryKeys)
        summaryLabel.attributedText = NSAttributedString(string: article.summary, attributes: summaryAttributes)

        dateLabel.text = article.date
        categoryLabel.text = article.category

        let remarkKeys = (
            lineSpacing: CGFloat(4),
            font: UIFont(name: "Avenir-Book", size: 10.0)!,
            foregroundColor: UIColor(code: "#ff3300")
        )
        let remarkAttributes = UILabelDecorator.getLabelAttributesBy(keys: remarkKeys)
        remarkLabel.attributedText = NSAttributedString(string: article.remark, attributes: remarkAttributes)
    }

    // MARK: - Private Function

    private func setupArticleListTableViewCell() {

        // UITableViewCellに関するそれ自体に関する設定
        self.accessoryType = .none
        self.selectionStyle = .none
    }
}
