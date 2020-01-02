//
//  ArticleCategoryPageItem.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/02.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import Parchment

// MEMO: ライブラリ「Parchment」で提供されているPagingItemプロトコルを適用する

struct ArticleCategoryPageItem: PagingItem, Hashable, Comparable {

    // MEMO: 割当てるのはEnum値とインデックス（ArticleCategoryPatternの数）の2つ

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
