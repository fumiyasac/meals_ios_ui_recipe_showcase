//
//  PhotoViewController.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/05.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit
import Combine

final class PhotoViewController: UIViewController {

    // MARK: - Property

    // sink(receiveCompletion:receiveValue:)実行時に返されるCancellableの保持用の変数
    private var cancellables: [AnyCancellable] = []

    // MEMO: API経由の非同期通信からデータを取得するためのViewModel
    private let viewModel: PhotoViewModel = PhotoViewModel(api: APIRequestManager.shared)

    // MEMO: UICollectionViewを差分更新するためのNSDiffableDataSourceSnapshot
    private var snapshot: NSDiffableDataSourceSnapshot<PhotoViewControllerSection, AnyHashable>!

    // MEMO: UICollectionViewを組み立てるためのDataSource
    private var dataSource: UICollectionViewDiffableDataSource<PhotoViewControllerSection, AnyHashable>! = nil

    // MARK: - @IBOutlet

    @IBOutlet weak private var collectionView: UICollectionView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
