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
    static func getArticles() -> [ArticleEntity] {

        let articles: [ArticleEntity] = (1...14).map{
            ArticleEntity(
                id: $0, title: "タイトル\($0)", catchcopy: "キャッチコピー\($0)",
                category: "カテゴリー\($0)", imageFileName: "sample\($0)"
            )
        }
        return articles.shuffled()
    }
}
