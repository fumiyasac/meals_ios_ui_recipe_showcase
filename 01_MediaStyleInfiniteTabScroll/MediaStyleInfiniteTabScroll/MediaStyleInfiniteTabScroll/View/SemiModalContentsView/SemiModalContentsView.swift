//
//  SemiModalContentsView.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/12/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: このViewはダミー表示用のものになるので、最低限のクラスだけ準備しています。
final class SemiModalContentsView: CustomViewBase {

    @IBOutlet weak private var messageLabel: UILabel!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupSemiModalContentsView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupSemiModalContentsView()
    }

    // MARK: - Private Function

    // SemiModalContentsViewの初期設定
    private func setupSemiModalContentsView() {

        // MEMO: Xcode11.1では右ペインのAttributeTextインスペクタの挙動が怪しい（クラッシュが頻発する）のでこの形にしています
        let message = "皆様のからの暖かいコメントが本当にいつも嬉しくって励みになっています。自分はまだまだ大したものでは決してありませんが、今後ともよいものを提供できるよう頑張ります。こちらのセミモーダル表示のサンプルにつきましては、偶然に同様な機能を実装することがありまして、その際に見つけたQiita記事を参考にして実装したものになります。記事を書いてくださいました、@iincho様には本当に感謝しております。そして、今回も素晴らしいサンプルと解説記事に敬意を込めて、今回のサンプルに盛り込んでみました次第です。またこの他にもカスタムトランジションに関して紹介されていた記事も参考にさせて頂きました。\nスワイプ処理を伴ったセミモーダル表示画面の実装についても、簡単そうに見えてしまうけれども実はなかなか一筋縄ではいかないUI表現の一つでもあるかと思います。実現したい実装を考えていく際に、もし自前でも実装が少し難しそうで時間がかかりそうだと判断した場合には、UIライブラリの活用も選択肢として視野に入れておくのも良いかと思います。"

        // MEMO: 概要部分表示用ラベルについてはテキスト属性による装飾を適用して表示する
        let messageKeys = (
            lineSpacing: CGFloat(8),
            font: UIFont(name: "HiraKakuProN-W3", size: 14.0)!,
            foregroundColor: UIColor(code: "#999999")
        )
        let messageAttributes = UILabelDecorator.getLabelAttributesBy(keys: messageKeys)
        messageLabel.attributedText = NSAttributedString(string: message, attributes: messageAttributes)
    }
}
