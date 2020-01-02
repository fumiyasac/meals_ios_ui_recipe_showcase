//
//  DetailDescriptionView.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/03.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import Nantes

final class DetailDescriptionView: CustomViewBase {

    @IBOutlet weak private var detailTitleLabel: UILabel!
    @IBOutlet weak private var detailDescriptionTitleLabel: NantesLabel!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupDetailDescriptionView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupDetailDescriptionView()
    }

    // MARK: - Private Function

    private func setupDetailDescriptionView() {

        setTitleLabel()
        setDescriptionLabel()
    }

    private func setTitleLabel() {

        let titleKeys = (
            lineSpacing: CGFloat(4),
            font: UIFont(name: "Avenir-Heavy", size: 15.0)!,
            foregroundColor: UIColor.black
        )
        let titleAttributes = UILabelDecorator.getLabelAttributesBy(keys: titleKeys)
        detailTitleLabel.attributedText = NSAttributedString(string: getTitleText(), attributes: titleAttributes)
    }

    private func setDescriptionLabel() {
        
        // MEMO: ライブラリ「Nantes」を利用したテキスト表示のトグル開閉を実現する処理

        // 行間や初期表示時の表示行数を決定する（※フォントは「Avenir」を利用）
        //detailDescriptionTitleLabel.lineSpacing = 0
        detailDescriptionTitleLabel.numberOfLines = 8

        // 続きをトグルで開閉する際の処理
        detailDescriptionTitleLabel.labelTappedBlock = { [weak self] in
            guard let self = self else { return }

            // MEMO: ラベルに設定された行数を見て、全て表示:0 / 一部表示:5とnumberOfLinesを切り替える
            self.detailDescriptionTitleLabel.numberOfLines = self.detailDescriptionTitleLabel.numberOfLines == 0 ? 8 : 0
            self.layoutIfNeeded()
        }

        // 表示対象のテキストを反映する
        detailDescriptionTitleLabel.text = getDescriptionText()

        // 一部表示時のラスト到達時に表示される「続きを読む」の押下エリアに関する調整
        let truncationTokenKeys = (
            lineSpacing: CGFloat(0),
            font: UIFont(name: "Avenir-Heavy", size: 12.0)!,
            foregroundColor: UIColor.darkGray
        )
        let truncationTokenAttributes = UILabelDecorator.getLabelAttributesBy(keys: truncationTokenKeys)
        detailDescriptionTitleLabel.attributedTruncationToken = NSAttributedString(string: " ... 続きを読む", attributes: truncationTokenAttributes)
    }

    private func getTitleText() -> String {

        let title =
"""
今回は1つ画面内に類似した表示要素を複数表示するような形でのUI実装をライブラリを活用して実施しました。
"""
        return title
    }

    private func getDescriptionText() -> String {

        let description =
"""
今回のサンプルについては、表現やデザインを綺麗に彩るためのライブラリを上手に活用した実装に加えて大胆なカスタムトランジションを組み込んでファッションECや動画配信等のコンテンツを提供するアプリからヒントとインスピレーションを得て、作成してみたサンプルとなっています。このサンプル中で利用しているライブラリ「Blueprints」と「Parchment」に関しては、私自身が実務の中で活用した経験もあったことやライブラリの動きの美しさにも惹かれたこともあったので、少し雑な形ではありますが、UIサンプル実装の中でうまく組み合わせて活用に至りました。特にUI系のライブラリについては、スター数の多さや知名度の高さからもはや定番とも言えるようなもの実務では活用するケースは結構多いかと思います。しかしながら、知名度が定番ライブラリと比べると少し低いUIライブラリであっても、その性質や仕様に目を向けて有効活用ができる可能性を探っていくこともまた、面白い発見や知見が得られるようなこともたくさんあります。用途に合わせて上手に活用していくためのアイデアと表現の引き出しを少しでも増やしていく活動をぜひほんのちょっとでも構いませんので、試してみると面白いかと思います。\nともすれば、なかなか答えが決めきれない事に対して苛立ってしまうことや思い通りの実装ができないことによる歯痒さを覚えてしまうかもしれませんが、何度も繰り返していくうちにつまづきは克服することができ、またそのつまづきを教訓として回避作を考えることもきっとできるようになります。答えを求めて足掻くことは他者から見ればあまり格好の良いものに見えないかもしれませんが、その泥臭くとも美しい部分にぜひ少しでも触れていただくことができれば、嬉しく思います。
"""
        return description
    }
}
