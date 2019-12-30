//
//  UILabelDecorator.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/12/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

final class UILabelDecorator {

    // MARK: - Static Function

    // 該当のUILabelに付与する属性を設定する
    static func getLabelAttributesBy(keys: (lineSpacing: CGFloat, font: UIFont, foregroundColor: UIColor)) -> [NSAttributedString.Key : Any] {

        // 行間に関する設定をする
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = keys.lineSpacing

        // 上記で定義した行間・フォント・色を属性値として設定する
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        attributes[NSAttributedString.Key.font] = keys.font
        attributes[NSAttributedString.Key.foregroundColor] = keys.foregroundColor

        return attributes
    }
}
