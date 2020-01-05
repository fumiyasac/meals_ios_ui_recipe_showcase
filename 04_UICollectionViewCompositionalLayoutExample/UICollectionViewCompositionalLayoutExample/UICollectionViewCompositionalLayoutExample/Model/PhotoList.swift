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
    let title: String
    let summary: String
    let image: Image
    let gift: Gift

    private(set) var height: CGFloat = 0.0
    
    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case title
        case summary
        case image
        case gift
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.image = try container.decode(Image.self, forKey: .image)
        self.gift = try container.decode(Gift.self, forKey: .gift)

        // MEMO: 写真のサイズに基づいて算出した縦横比を利用して適用したセルのサイズを算出する
        let screenHalfWidth = UIScreen.main.bounds.width * 0.5
        let ratio = CGFloat(self.image.height) / CGFloat(self.image.width)
        let titleAndSummaryHeight: CGFloat = 90.0

        self.height = screenHalfWidth * ratio + titleAndSummaryHeight
    }
    
    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Photo Extension

extension Photo {

    struct Image: Decodable {
        let url: String
        let width: Int
        let height: Int
    }

    struct Gift: Decodable {
        let flag: Bool
        let price: Int?
    }
}
