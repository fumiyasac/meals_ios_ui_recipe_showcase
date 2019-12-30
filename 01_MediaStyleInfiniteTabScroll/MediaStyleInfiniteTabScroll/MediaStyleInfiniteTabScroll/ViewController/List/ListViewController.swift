//
//  ListViewController.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/10/29.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {

    // MARK: - Properties

    private var selectedCategoryArticles: [ArticleEntity] = [] {
        didSet {
            self.listCollectionView.reloadData()
        }
    }

    // MARK: - @IBOutlets

    @IBOutlet weak private var listCollectionView: UICollectionView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupListCollectionView()
    }

    // MARK: - Function

     func setArticles(articles: [ArticleEntity]) {
        selectedCategoryArticles = articles
     }

    // MARK: - Private Function

    private func setupListCollectionView() {
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.registerCustomCell(ListCollectionViewCell.self)
        listCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate

extension ListViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension ListViewController: UICollectionViewDataSource {

    // 配置するセルの個数を設定する
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCategoryArticles.count
    }

    // 配置するセルの表示内容を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCustomCell(with: ListCollectionViewCell.self, indexPath: indexPath)
        cell.setCellData(selectedCategoryArticles[indexPath.row])
        cell.setCellDecoration()
        return cell
    }

    // セル押下時の処理内容を記載する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let sb = UIStoryboard(name: "Detail", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! DetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ListViewController: UICollectionViewDelegateFlowLayout {

    // セルのサイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ListCollectionViewCell.getCellSize()
    }

    // セルの垂直方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ListCollectionViewCell.cellMargin
    }

    // セルの水平方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ListCollectionViewCell.cellMargin
    }

    // セル内のアイテム間の余白(margin)調整を行う
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin = ListCollectionViewCell.cellMargin
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
}
