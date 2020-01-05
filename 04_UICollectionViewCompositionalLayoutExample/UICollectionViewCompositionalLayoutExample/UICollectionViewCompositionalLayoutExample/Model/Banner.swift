//
//  Banner.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/05.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

struct Banner: Hashable, Decodable {

    let id: Int
    let title: String
    let imageUrl: String
    let dateString: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case title
        case imageUrl = "image_url"
        case dateString = "date_string"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.dateString = try container.decode(String.self, forKey: .dateString)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Banner, rhs: Banner) -> Bool {
        return lhs.id == rhs.id
    }
}
