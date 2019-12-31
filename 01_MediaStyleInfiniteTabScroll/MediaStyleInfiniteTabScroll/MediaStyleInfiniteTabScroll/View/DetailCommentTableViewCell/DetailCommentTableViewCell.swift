//
//  DetailCommentTableViewCell.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/11/23.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

final class DetailCommentTableViewCell: UITableViewCell {

    @IBOutlet weak private var commentMessageLabel: UILabel!
    @IBOutlet weak private var commentUserNameLabel: UILabel!
    @IBOutlet weak private var commentDateLabel: UILabel!

    // MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()

        setupDetailCommentTableViewCell()
    }

    // MARK: - Function

    func setCell(_ comment: ArticleCommentEntity) {

        // MEMO: コメント部分表示用ラベルについてはテキスト属性による装飾を適用して表示する
        let messageKeys = (
            lineSpacing: CGFloat(8),
            font: UIFont(name: "HiraKakuProN-W3", size: 14.0)!,
            foregroundColor: UIColor(code: "#999999")
        )
        let messageAttributes = UILabelDecorator.getLabelAttributesBy(keys: messageKeys)
        commentMessageLabel.attributedText = NSAttributedString(string: comment.message, attributes: messageAttributes)

        commentUserNameLabel.text = comment.username
        commentDateLabel.text = comment.dateString
    }

    // MARK: - Private Function

    private func setupDetailCommentTableViewCell() {

        // UITableViewCellに関するそれ自体に関する設定
        self.accessoryType = .none
        self.selectionStyle = .none
    }
}
