//
//  UIColorExtension.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2019/12/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// UIColorの拡張
extension UIColor {

    // 16進数のカラーコードをiOSの設定に変換するメソッド

    // 参考：【Swift】Tips: あると便利だったextension達(UIColor編)
    // https://dev.classmethod.jp/smartphone/utilty-extension-uicolor/
    // iOS13での変更点: scanHexInt32がdeprecatedとなったのでscanHexInt64を使用する
    convenience init(code: String, alpha: CGFloat = 1.0) {
        var color: UInt64 = 0
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        if Scanner(string: code.replacingOccurrences(of: "#", with: "")).scanHexInt64(&color) {
            r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            g = CGFloat((color & 0x00FF00) >>  8) / 255.0
            b = CGFloat( color & 0x0000FF       ) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

// publicなUIColorの拡張
// (参考) https://github.com/kyleweiner/UIColor-Interpolation

public extension UIColor {

    // 任意のUIColorインスタンスにおける色定義をRed・Green・Blue・アルファ値の数値（0〜1の区間）に分解したものを返す
    var components: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let components = self.cgColor.components!
        switch components.count == 2 {
        case true : return (r: components[0], g: components[0], b: components[0], a: components[1])
        case false: return (r: components[0], g: components[1], b: components[2], a: components[3])
        }
    }

    // 任意のUIColorインスタンスにおける変更前 → 変更後での補間を伴う色変化実行する
    static func interpolate(from fromColor: UIColor, to toColor: UIColor, with progress: CGFloat) -> UIColor {

        let fromComponents = fromColor.components
        let toComponents = toColor.components
        let r = (1 - progress) * fromComponents.r + progress * toComponents.r
        let g = (1 - progress) * fromComponents.g + progress * toComponents.g
        let b = (1 - progress) * fromComponents.b + progress * toComponents.b
        let a = (1 - progress) * fromComponents.a + progress * toComponents.a
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
