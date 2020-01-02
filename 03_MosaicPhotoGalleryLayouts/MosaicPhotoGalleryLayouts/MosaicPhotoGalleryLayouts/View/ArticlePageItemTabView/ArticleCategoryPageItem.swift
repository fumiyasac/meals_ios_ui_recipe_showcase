//
//  ArticleCategoryPageItem.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/02.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import Parchment

//

struct ArticleCategoryPageItem: PagingItem, Hashable, Comparable {

    let type: ArticleCategoryPattern
    let index: Int

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }

    static func ==(lhs: ArticleCategoryPageItem, rhs: ArticleCategoryPageItem) -> Bool {
        return lhs.type == rhs.type
    }

    // MARK: - Comparable

    static func <(lhs: ArticleCategoryPageItem, rhs: ArticleCategoryPageItem) -> Bool {
        return lhs.index < rhs.index
    }
}
