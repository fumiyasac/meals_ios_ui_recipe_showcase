//
//  ArticleModel.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/12/30.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class ArticleModel {

    // MARK: - Static Function

    // 14個分のサンプルデータを作成する
    static func getSampleArticles() -> [ArticleEntity] {

        let articles: [ArticleEntity] = (1...14).map{
            ArticleEntity(
                id: $0, title: "タイトル\($0)", catchcopy: "キャッチコピー\($0)",
                category: "カテゴリー\($0)", imageFileName: "sample\($0)"
            )
        }
        // MEMO: 組み立てたデータをすシャッフルする
        // (参考) https://qiita.com/BMJr/items/913e031f78f44d9675f8
        return articles.shuffled()
    }
}
