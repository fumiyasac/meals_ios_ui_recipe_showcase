//
//  MosaicCollectionViewLayoutPattern.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2019/12/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import Blueprints

enum MosaicCollectionViewLayoutPattern {

    case first
    case second
    case third

    // MARK: - Function

    // ライブラリ「BluePrints」で提供しているレイアウト構造のパターン定義一覧
    // 参照URL: https://github.com/zenangst/Blueprints
    // → MosaicスタイルのUICollectionViewを用いても結構煩雑になりやすいためこのライブラリで補う方針としている

    func getLayoutPattern() -> VerticalMosaicBlueprintLayout {

        // セルの行間とレイアウトパターンパターン分の高さを設定する
        let cellMargin: CGFloat = 6.0
        let basePatternHeight = UIScreen.main.bounds.width * 1.2

        switch self {
        case .first:
            return VerticalMosaicBlueprintLayout(
                patternHeight: basePatternHeight,
                minimumInteritemSpacing: cellMargin,
                minimumLineSpacing: cellMargin,
                sectionInset: EdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin),
                patterns: [
                    // MEMO: 下記4つのパターンで10件分のセルレイアウトになるのでこれを1セットとみなして適用する
                    MosaicPattern(alignment: .left, direction: .vertical, amount: 1, multiplier: 0.5),
                    MosaicPattern(alignment: .left, direction: .horizontal, amount: 2, multiplier: 0.33),
                    MosaicPattern(alignment: .left, direction: .vertical, amount: 2, multiplier: 0.67),
                    MosaicPattern(alignment: .left, direction: .vertical, amount: 1, multiplier: 0.5),
                    // MEMO: 下記4つのパターンで10件分のセルレイアウトになるのでこれを1セットとみなして適用する
                    MosaicPattern(alignment: .left, direction: .vertical, amount: 1, multiplier: 0.5),
                    MosaicPattern(alignment: .left, direction: .horizontal, amount: 2, multiplier: 0.34),
                    MosaicPattern(alignment: .right, direction: .vertical, amount: 2, multiplier: 0.66),
                    MosaicPattern(alignment: .left, direction: .vertical, amount: 1, multiplier: 0.5)
                ]
            )
        case .second:
            return VerticalMosaicBlueprintLayout(
                patternHeight: basePatternHeight,
                minimumInteritemSpacing: cellMargin,
                minimumLineSpacing: cellMargin,
                sectionInset: EdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin),
                patterns: [
                    // MEMO: 下記4つのパターンで10件分のセルレイアウトになるのでこれを1セットとみなして適用する
                    MosaicPattern(alignment: .left, direction: .horizontal, amount: 2, multiplier: 0.33),
                    MosaicPattern(alignment: .left, direction: .horizontal, amount: 2, multiplier: 0.33),
                    MosaicPattern(alignment: .left, direction: .vertical, amount: 1, multiplier: 0.5),
                    MosaicPattern(alignment: .left, direction: .vertical, amount: 1, multiplier: 0.5)
                ]
            )
        case .third:
            return VerticalMosaicBlueprintLayout(
                patternHeight: basePatternHeight,
                minimumInteritemSpacing: cellMargin,
                minimumLineSpacing: cellMargin,
                sectionInset: EdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin),
                patterns: [
                    // MEMO: 下記4つのパターンで10件分のセルレイアウトになるのでこれを1セットとみなして適用する
                    MosaicPattern(alignment: .left, direction: .vertical, amount: 2, multiplier: 0.67),
                    MosaicPattern(alignment: .right, direction: .vertical, amount: 2, multiplier: 0.67),
                    MosaicPattern(alignment: .left, direction: .vertical, amount: 1, multiplier: 0.5),
                    MosaicPattern(alignment: .left, direction: .vertical, amount: 1, multiplier: 0.5)
                ]
            )
        }
    }
}
