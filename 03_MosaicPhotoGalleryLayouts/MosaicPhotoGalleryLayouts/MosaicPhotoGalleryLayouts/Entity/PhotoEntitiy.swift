//
//  PhotoEntitiy.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2020/01/03.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct PhotoEntitiy {

    let id: Int
    let title: String
    let category: String
    let date: String
    let imageFile: UIImage?

    // MARK: - Initializer

    init(id: Int, title: String, category: String, date: String, imageFileName: String) {
        self.id = id
        self.title = title
        self.category = category
        self.date = date
        self.imageFile = UIImage(named: imageFileName)
    }
}
