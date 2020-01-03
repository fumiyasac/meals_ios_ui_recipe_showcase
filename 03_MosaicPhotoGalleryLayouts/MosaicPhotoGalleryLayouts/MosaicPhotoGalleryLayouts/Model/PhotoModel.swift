//
//  PhotoModel.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/03.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

class PhotoModel {

    // MARK: - Static Function

    // 20個分のサンプルデータを作成する
    static func getSamplePhotos() -> [PhotoEntitiy] {

        let photos: [PhotoEntitiy] = (1...20).map{
            PhotoEntitiy(
                id: $0,
                title: "Title\($0)",
                category: "Category\($0)",
                date: "2020.01.03",
                imageFileName: "image\($0)"
            )
        }
        return photos
    }
}
