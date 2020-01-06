//
//  UILabelDecorator.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/06.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

final class UILabelDecorator {

    // MARK: - Static Function

    // 該当のUILabelに付与する属性を設定する
    static func getLabelLineSpacingAttributes(_ lineSpacing: CGFloat) -> [NSAttributedString.Key : Any] {

        // 行間に関する設定をする
        // MEMO: lineBreakModeの指定しないと、行数指定をしたUILabelでテキストがはみ出た場合の「...」が出なくなる
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineBreakMode = .byTruncatingTail

        // 引数で受け取った行間を属性値として設定する
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle

        return attributes
    }
}
