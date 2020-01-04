//
//  MainViewController.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2019/12/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class MainViewController: UIViewController {

    // MARK: - Property

    // MARK: - @IBOutlet

    @IBOutlet weak private var photoContainerView: UIView!
    @IBOutlet weak private var searchContainerView: UIView!
    @IBOutlet weak private var screenSegmentControl: BetterSegmentedControl!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

