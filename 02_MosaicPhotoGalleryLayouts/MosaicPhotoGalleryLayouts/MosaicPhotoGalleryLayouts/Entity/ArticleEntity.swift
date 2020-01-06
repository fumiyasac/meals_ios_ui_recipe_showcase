//
//  ArticleEntity.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/03.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

struct ArticleEntity {

    let id: Int
    let title: String
    let summary: String
    let category: String
    let date: String
    let remark: String

    // MARK: - Initializer

    init(id: Int, title: String, summary: String, category: String, date: String, remark: String) {
        self.id = id
        self.title = title
        self.summary = summary
        self.category = category
        self.date = date
        self.remark = remark
    }
}
