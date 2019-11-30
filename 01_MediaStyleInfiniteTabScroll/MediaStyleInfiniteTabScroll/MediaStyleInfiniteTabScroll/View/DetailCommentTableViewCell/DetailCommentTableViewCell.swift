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
    }

    // MARK: - Function
}
