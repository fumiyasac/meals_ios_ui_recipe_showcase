//
//  SearchViewController.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/05.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit
import Combine

// MARK: - Enum

enum SearchSection: Int, CaseIterable {
    case keywordList
}

final class SearchViewController: UIViewController {

    // MARK: - Property

    // UITableViewに設置するRefreshControl
    private let searchRefrashControl = UIRefreshControl()

    // sink(receiveCompletion:receiveValue:)実行時に返されるCancellableの保持用の変数
    private var cancellables: [AnyCancellable] = []

    // MEMO: API経由の非同期通信からデータを取得するためのViewModel
    // 補足: Mockに接続する場合はMockAPIRequestManager.sharedを設定する（実機検証時等の場合）
    private let viewModel: SearchViewModel = SearchViewModel(api: APIRequestManager.shared)

    // MEMO: UICollectionViewCompositionalLayout & DiffableDataSourceの設定
    private var snapshot: NSDiffableDataSourceSnapshot<SearchSection, Keyword>!
    private var dataSource: UITableViewDiffableDataSource<SearchSection, Keyword>! = nil

    // MARK: - @IBOutlet

    @IBOutlet weak private var tableView: UITableView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        // UITableViewに関する設定
        setupSearchTableView()
        bindToViewModelOutputs()
    }

    // MARK: - Private Function

    // UITableViewにおけるPullToRefresh実行時の処理
    @objc private func executeRefresh() {

        // MEMO: ViewModelに定義した表示データのリフレッシュ処理を実行する
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {

            // NSDiffableDataSourceの内容をリセットした後にAPIリクエストを実行する
            self.resetDiffableDataSource()
            self.viewModel.inputs.refreshTrigger.send()
        }
    }

    // UITableViewに関する初期設定
    private func setupSearchTableView() {

        // MEMO: UITableViewで表示するセルの登録
        tableView.registerCustomCell(KeywordTableViewCell.self)

        // MEMO: UITableViewでのRefreshControlに関する設定
        tableView.refreshControl = searchRefrashControl
        searchRefrashControl.addTarget(self, action: #selector(executeRefresh), for: .valueChanged)

        // MEMO: UITableViewDelegateの設定
        tableView.delegate = self

        // MEMO: UITableViewCellの高さとした方向の隙間設定
        tableView.rowHeight = 58.0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 84, right: 0)

        // MEMO: DataSourceはUITableViewDiffableDataSourceを利用してUITableViewCellを継承したクラスを組み立てる
        dataSource = UITableViewDiffableDataSource<SearchSection, Keyword>(tableView: tableView) { (tableView: UITableView, indexPath: IndexPath, keyword: Keyword) -> UITableViewCell? in

            let cell = tableView.dequeueReusableCustomCell(with: KeywordTableViewCell.self)
            cell.setCell(keyword)
            return cell
        }

        // MEMO: ViewModelのInputsを経由したAPIでのデータ取得処理を実行する
        resetDiffableDataSource()
        viewModel.inputs.fetchKeywordTrigger.send()
    }

    // ViewModelのOutputとこのViewControllerでのUIに関する処理をバインドする
    private func bindToViewModelOutputs() {

        // MEMO: APIへのリクエスト状態に合わせたUI側の表示におけるハンドリングを実行する
        viewModel.outputs.apiRequestStatus
            .subscribe(on: RunLoop.main)
            .sink(
                receiveValue: { [weak self] status in

                    guard let self = self else { return }
                    switch status {
                    case .requesting:
                        self.searchRefrashControl.beginRefreshing()
                    default:
                        self.searchRefrashControl.endRefreshing()
                    }
                }
            )
            .store(in: &cancellables)

        // MEMO: APIへのリクエスト状態に合わせたUI側の表示におけるハンドリングを実行する
        viewModel.outputs.keywords
            .subscribe(on: RunLoop.main)
            .sink(
                receiveValue: { [weak self] newKeywords in
                    guard let self = self else { return }
                    let oldKeywords = self.snapshot.itemIdentifiers(inSection: .keywordList)
                    self.snapshot.deleteItems(oldKeywords)
                    self.snapshot.appendItems(newKeywords, toSection: .keywordList)
                    self.dataSource.apply(self.snapshot, animatingDifferences: false)
                }
            )
            .store(in: &cancellables)
    }

    // NSDiffableDataSourceSnapshotの初期化処理
    private func resetDiffableDataSource() {

        snapshot = NSDiffableDataSourceSnapshot<SearchSection, Keyword>()
        snapshot.appendSections(SearchSection.allCases)
        for section in SearchSection.allCases {
            snapshot.appendItems([], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // MEMO: 該当のセクションとIndexPathからNSDiffableDataSourceSnapshot内の該当する値を取得する
        if let targetSection = SearchSection(rawValue: indexPath.section) {
            let targetSnapshot = snapshot.itemIdentifiers(inSection: .keywordList)
            print("Section: ", targetSection)
            print("IndexPath.row: ", indexPath.row)
            print("Model: ", targetSnapshot[indexPath.row])
        }
    }
}
