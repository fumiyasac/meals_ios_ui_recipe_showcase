//
//  RecommendCollectionHeaderView.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/06.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class RecommendCollectionHeaderView: UICollectionReusableView {

    // MARK: - @IBOutlet

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!

    // MARK: - Function

    func setHeader(title: String, description: String) {

        titleLabel.text = title
        descriptionLabel.text = description
    }
}
