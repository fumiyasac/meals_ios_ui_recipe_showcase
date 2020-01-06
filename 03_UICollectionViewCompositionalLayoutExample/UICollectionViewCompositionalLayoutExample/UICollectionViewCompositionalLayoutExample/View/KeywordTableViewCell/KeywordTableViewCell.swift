//
//  KeywordTableViewCell.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/06.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class KeywordTableViewCell: UITableViewCell {

    // MARK: - @IBOutlet

    @IBOutlet weak private var keywordLabel: UILabel!
    @IBOutlet weak private var kanaLabel: UILabel!

    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()

        self.accessoryType = .none
        self.selectionStyle = .none
    }

    // MARK: - Function

    func setCell(_ keyword: Keyword) {

        keywordLabel.text = keyword.keyword
        kanaLabel.text = keyword.kana
    }
}
