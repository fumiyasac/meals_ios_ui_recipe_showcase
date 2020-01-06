//
//  PhotoList.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/05.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Struct (PhotoList)

struct PhotoList: Hashable, Decodable {

    private let uuid = UUID()

    let page: Int
    let photos: [Photo]
    let hasNextPage: Bool

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case page
        case photos
        case hasNextPage = "has_next_page"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.page = try container.decode(Int.self, forKey: .page)
        self.photos = try container.decode([Photo].self, forKey: .photos)
        self.hasNextPage = try container.decode(Bool.self, forKey: .hasNextPage)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func == (lhs: PhotoList, rhs: PhotoList) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

// MARK: - Struct (Photo)

struct Photo: Hashable, Decodable {

    let id: Int
    let profileName: String
    let dateString: String
    let imageUrl: String
    let title: String
    let description: String

    private let uuid = UUID()

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case profileName = "profile_name"
        case dateString = "date_string"
        case imageUrl = "image_url"
        case title
        case description
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.profileName = try container.decode(String.self, forKey: .profileName)
        self.dateString = try container.decode(String.self, forKey: .dateString)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
