//
//  Recommend.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/05.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

struct Recommend: Hashable, Decodable {

    let id: Int
    let category: String
    let title: String
    let imageUrl: String

    private let uuid = UUID()

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case category
        case title
        case imageUrl = "image_url"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.category = try container.decode(String.self, forKey: .category)
        self.title = try container.decode(String.self, forKey: .title)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func == (lhs: Recommend, rhs: Recommend) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
