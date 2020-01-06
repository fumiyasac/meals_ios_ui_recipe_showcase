//
//  Keyword.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/05.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

struct Keyword: Hashable, Decodable {

    let id: Int
    let keyword: String
    let kana: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case keyword
        case kana
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.keyword = try container.decode(String.self, forKey: .keyword)
        self.kana = try container.decode(String.self, forKey: .kana)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Keyword, rhs: Keyword) -> Bool {
        return lhs.id == rhs.id
    }
}
