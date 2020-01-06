//
//  ArticleModel.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/03.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

class ArticleModel {
    
    // MARK: - Static Function

    // 8個分のサンプルデータを作成する
    static func getSampleArticles() -> [ArticleEntity] {

        let article: [ArticleEntity] = (1...8).map{
            ArticleEntity(
                id: $0,
                title: "○○が選んだ、こだわりの特選記事セレクション No.\($0)",
                summary: "こちらは、サンプル記事コンテンツ内における「○○が選んだ、こだわりの特選記事セレクション No.\($0)」の概要になります。編集部の選りすぐりの記事をじっくりとご堪能くださいませ！",
                category: "お楽しみコンテンツ集",
                date: "2020.01.03",
                remark: "※こちらは期間限定のコンテンツになりますので、ご注意下さい。"
            )
        }
        return article
    }
}
