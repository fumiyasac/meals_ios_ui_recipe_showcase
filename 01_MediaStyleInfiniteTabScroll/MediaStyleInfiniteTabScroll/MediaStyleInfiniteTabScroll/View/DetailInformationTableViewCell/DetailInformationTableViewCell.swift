//
//  DetailInformationTableViewCell.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/11/23.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

final class DetailInformationTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets

    @IBOutlet weak private var informationTitleLabel: UILabel!
    @IBOutlet weak private var informationSummaryLabel: UILabel!

    // MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()

        setupDetailInformationTableViewCell()
    }

    // MARK: - Function

    func setCell(_ information: ArticleInformationEntity) {

        // MEMO: 概要部分表示用ラベルについてはテキスト属性による装飾を適用して表示する
        let summaryKeys = (
            lineSpacing: CGFloat(8),
            font: UIFont(name: "HiraKakuProN-W3", size: 11.0)!,
            foregroundColor: UIColor(code: "#999999")
        )
        let summaryAttributes = UILabelDecorator.getLabelAttributesBy(keys: summaryKeys)
        informationSummaryLabel.attributedText = NSAttributedString(string: information.summary, attributes: summaryAttributes)

        informationTitleLabel.text = information.title
    }

    // MARK: - Private Function

    private func setupDetailInformationTableViewCell() {

        // UITableViewCellに関するそれ自体に関する設定
        self.accessoryType = .none
        self.selectionStyle = .none
    }
}
