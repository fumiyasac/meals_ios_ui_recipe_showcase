//
//  ArticleEntity.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/12/30.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct ArticleEntity {

    let id: Int
    let title: String
    let catchcopy: String
    let category: String
    let imageFile: UIImage?

    // MARK: - Initializer

    init(id: Int, title: String, catchcopy: String, category: String, imageFileName: String) {
        self.id = id
        self.title = title
        self.catchcopy = catchcopy
        self.category = category
        self.imageFile = UIImage(named: imageFileName)
    }
}
