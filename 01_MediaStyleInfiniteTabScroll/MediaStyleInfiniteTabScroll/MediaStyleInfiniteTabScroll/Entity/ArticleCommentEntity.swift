//
//  ArticleCommentEntity.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/12/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation

struct ArticleCommentEntity {

    let username: String
    let message: String
    let dateString: String

    // MARK: - Initializer

    init(username: String, message: String, dateString: String) {
        self.username = username
        self.message = message
        self.dateString = dateString
    }
}
