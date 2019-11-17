//
//  DetailViewController.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/10/28.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

// MEMO: InterfaceBuilderに配置したUIScrollViewにおいては「Content Layout Guide」のチェックを外す
// https://stackoverflow.com/questions/56570660/how-to-fix-scrollable-content-size-ambiguity-in-xcode-11-ios-12-ios-13-usin

final class DetailViewController: UIViewController {

    // MARK: - @IBOutlets
    
    @IBOutlet weak private var detailScrollView: UIScrollView!

    @IBOutlet weak private var detailInformationTableView: UITableView!
    @IBOutlet weak private var detailCommentTableView: UITableView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDetailScrollView()
    }

    // MARK: - Private Function

    private func setupDetailScrollView() {
        detailScrollView.delegate = self
        detailScrollView.isPagingEnabled = true
    }

    /*
    private func setupTableViewsInDetailScrollView() {
        
        // MEMO: detailInformationTableViewの初期設定
        detailInformationTableView.delegate = self
        detailInformationTableView.dataSource = self
        
        // MEMO: detailCommentTableViewの初期設定
        detailCommentTableView.delegate = self
        detailCommentTableView.dataSource = self
    }
    */
}

// MARK: - UIScrollViewDelegate

extension DetailViewController: UIScrollViewDelegate {

}
