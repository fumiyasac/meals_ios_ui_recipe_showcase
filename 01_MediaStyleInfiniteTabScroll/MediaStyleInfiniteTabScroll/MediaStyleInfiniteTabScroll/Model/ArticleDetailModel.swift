//
//  ArticleDetailModel.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/12/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class ArticleDetailModel {

    // MARK: - Static Function

    // 詳細情報表示用のサンプルデータを作成する
    static func getSampleInformation() -> [ArticleInformationEntity] {

        let introduction = ArticleInformationEntity(
            title: "詳細情報の概要",
            summary:  "こちらのサンプルについてはInstagram等の写真投稿アプリやメディアアプリの様な読み物系コンテンツ表示アプリでのプロフィールページのような表現を再現したものになります。結構お目にかかる頻度も多い表現の一つではあるんですが、いざ自分で実装をしようとUI構造を考えていく場合にはなかなか難しさがあるのではないかと思います。\nかくいう私自身も最初この表現を実装しようとして想像以上に時間がかかってしまったり、InterfaceBuilderの中が複雑な感じになってしまって、「なんか違う」という状態になることがしばしばありました。また、今回の様にタブ形式の状態で実装が必要な場合には上下のスクロールのみならず、左右のスクロールが生じる状態についても考えないといけない点にも難しさをはらんいる点にも注意が必要になるかと思います。"
        )
        let point = ArticleInformationEntity(
            title: "今回の実装におけるワンポイント",
            summary: "この表現を実現する上でポイントになる点は「UIScrollViewを利用したUITableViewまたはUICollectionViewを入れ子構造にしてしまう点」にあるかと思います。まずはベースとなるUIScrollViewの中にUIStackViewを配置し、横方向に並べる様な形で必要なUITableViewまたはUICollectionViewを配置していく様な形を取ります。次にスクロールする対象がどの要素であるかを判断して、スクロールのハンドリングを実施するために、UIScrollViewDelegateを利用します。scrollViewDidScrollを利用してスクロール対象の配置要素におけるオフセット値を調整するような形に持っていくと良さそうです。"
        )
        let appendix = ArticleInformationEntity(
            title: "補足情報",
            summary: "今回紹介した方法の他にも、プロフィール画面の構成自体をUIScrollViewではなく単一のUITableViewやUICollectionViewのHeader部分を利用して実装する方法も考えられるかと思いますが、この場合Header部分の画像に対してパララックスを実装する等の表現は実現できますが、2つのコンテンツを並べて表示するような構造を実現する場合は難しくなってしまいます。実現したい画面の構造や表示データの取得タイミング等の条件を確認した上で、要件に沿った実装方針を採用すると良い選択ができるのではないかと思います。"
        )
        let column = ArticleInformationEntity(
            title: "コラム",
            summary: "以前にメディア系のアプリ開発をしていた経緯もあってか、このようなUI実装や表現を考察したり実装方法を紐解いていく作業や試行錯誤をする時間は私にとっては結構楽しい時間でもあります。この経験が元になって、様々なiOSアプリにおける気になった表現や綺麗なアニメーションやインタラクションに関する実装方針の考察やサンプルアプリの開発、ひいてはUI実装に関するTIPS集の執筆など今日における活動の礎となっています。流石に「仕事＝趣味」という感じでは決してありませんが、このような活動をずっと継続していくと同時に、実務の中でも生かしていけるような引き出しをこれからも増やし続けていきたいと感じています。"
        )
        // MEMO: こちらはテスト用に同じ値を繰り返して入れています
        return [introduction, point, appendix, column]
    }

    // 20個分のサンプルデータを作成する
    static func getSampleComments() -> [ArticleCommentEntity] {

        let articles: [ArticleCommentEntity] = (1...10).map{
            ArticleCommentEntity(
                username: "ユーザーNo.\($0)",
                message: "こちらはサンプルのコメントになります。\nコメントの詳細な内容に関してですが、あくまで表示サンプル用に作成したダミーのデタラメな文章になりますが、その点ご了承ください。",
                dateString: "2019.12.30"
            )
        }
        return articles
    }
}
