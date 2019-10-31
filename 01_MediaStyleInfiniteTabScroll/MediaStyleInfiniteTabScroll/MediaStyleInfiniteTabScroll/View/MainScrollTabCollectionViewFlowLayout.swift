//
//  MainScrollTabCollectionViewFlowLayout.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/10/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

final class MainScrollTabCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // 参考1: 下記のリンクで紹介されていたTIPSを元に実装しました
    // https://uruly.xyz/carousel-infinite-scroll-3/

    // 参考2: UICollectionViewのlayoutAttributeの変更タイミングに関する記事
    // https://qiita.com/kazuhiro4949/items/03bc3d17d3826aa197c0

    // 参考3: UICollectionViewFlowLayoutのサブクラスを利用したスクロールの停止位置算出に関する記事
    // https://dev.classmethod.jp/smartphone/iphone/collection-view-layout-cell-snap/

    // MARK: - Properties

    // 該当のセルのオフセット値を計算するための値（スクリーンの幅 - タブ表示用UICollectionViewに配置しているセルの幅）
    private let horizontalTargetOffsetWidth: CGFloat = UIScreen.main.bounds.width - MainScrollTabCollectionViewCell.cellSize.width

    // MARK: - Override

    // UICollectionViewをスクロールした後の停止位置を返す
    // MEMO: UICollectionViewのLayoutAttributeを調整して、中央に表示されるように調整している
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        // 配置されているUICollectionViewを取得する
        guard let conllectionView = self.collectionView else {
            assertionFailure("UICollectionViewが配置されていません。")
            return CGPoint.zero
        }
        // UICollectionViewのオフセット値を元に該当のセルの情報を取得する
        var offsetAdjustment: CGFloat = CGFloat(MAXFLOAT)
        let horizontalOffest: CGFloat = proposedContentOffset.x + horizontalTargetOffsetWidth / 2
        let targetRect = CGRect(
            x: proposedContentOffset.x,
            y: 0,
            width: conllectionView.bounds.size.width,
            height: conllectionView.bounds.size.height
        )

        // 配置されているUICollectionViewのlayoutAttributesを元にして停止させたい位置を算出する
        guard let layoutAttributes = super.layoutAttributesForElements(in: targetRect) else {
            assertionFailure("配置したUICollectionViewにおいて該当セルにおけるlayoutAttributesを取得できません。")
            return CGPoint.zero
        }
        for layoutAttribute in layoutAttributes {
            let itemOffset = layoutAttribute.frame.origin.x
            if abs(itemOffset - horizontalOffest) < abs(offsetAdjustment) {
                offsetAdjustment = itemOffset - horizontalOffest
            }
        }

        return CGPoint(
            x: proposedContentOffset.x + offsetAdjustment,
            y: proposedContentOffset.y
        )
    }
}
