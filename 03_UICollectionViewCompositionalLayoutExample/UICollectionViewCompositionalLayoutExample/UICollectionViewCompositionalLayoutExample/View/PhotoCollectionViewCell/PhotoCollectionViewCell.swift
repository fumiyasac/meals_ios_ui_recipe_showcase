//
//  PhotoCollectionViewCell.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/06.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit
import Nuke

class PhotoCollectionViewCell: UICollectionViewCell {

    // MARK: - @IBOutlet

    @IBOutlet weak private var profileNameLabel: UILabel!
    @IBOutlet weak private var dateStringLabel: UILabel!
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!

    // MARK: - Function

    func setCell(_ photo: Photo) {

        // MEMO: Nukeでの画像キャッシュと表示に関するオプション設定
        let imageDisplayOptions = ImageLoadingOptions(transition: .fadeIn(duration: 0.33))
        if let imageUrl = URL(string: photo.imageUrl) {
            Nuke.loadImage(with: imageUrl, options: imageDisplayOptions, into: thumbnailImageView)
        }

        profileNameLabel.text = photo.profileName
        dateStringLabel.text = photo.dateString

        titleLabel.attributedText = NSAttributedString(string: photo.title, attributes: UILabelDecorator.getLabelLineSpacingAttributes(4.0))
        descriptionLabel.attributedText = NSAttributedString(string: photo.description, attributes: UILabelDecorator.getLabelLineSpacingAttributes(6.0))
    }
}
