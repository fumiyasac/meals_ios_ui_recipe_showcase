//
//  ArticleCategoryPattern.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/02.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

enum ArticleCategoryPattern: Int, CaseIterable {

    case first
    case second
    case third
    case fourth
    case fifth

    // MARK: - Function

    func getTabTitle() -> String {
        switch self {
        case .first:
            return "1番目の記事"
        case .second:
            return "2番目の記事"
        case .third:
            return "3番目の記事"
        case .fourth:
            return "4番目の記事"
        case .fifth:
            return "5番目の記事"
        }
    }
}
