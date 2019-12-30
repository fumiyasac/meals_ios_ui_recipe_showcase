//
//  ArticleInformationEntity.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/12/30.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation

struct ArticleInformationEntity {

    let title: String
    let summary: String

    // MARK: - Initializer

    init(title: String, summary: String) {
        self.title = title
        self.summary = summary
    }
}
