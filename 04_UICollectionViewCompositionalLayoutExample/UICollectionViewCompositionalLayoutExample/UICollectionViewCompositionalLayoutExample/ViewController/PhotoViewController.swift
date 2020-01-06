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

    // MEMO: UICollectionViewCompositionalLayoutの設定（※Sectionごとに読み込ませて利用する）
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            switch sectionIndex {

            // MainSection: 0
            case PhotoViewControllerSection.banners.rawValue:
                return self?.createBannersLayout()

            // MainSection: 1
            case PhotoViewControllerSection.recommends.rawValue:
                return self?.createRecommends()

            // MainSection: 2
            case PhotoViewControllerSection.photos.rawValue:
                return self?.createPhotosLayout()

            default:
                fatalError()
            }
        }
        return layout
    }()

    // MARK: - @IBOutlet

    @IBOutlet weak private var collectionView: UICollectionView!

    // MARK: - deinit

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        bindToMainViewModelOutputs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // MEMO: ViewModelのInputsを経由したAPIでのデータ取得処理を実行する
        viewModel.inputs.fetchBannersTrigger.send()
        viewModel.inputs.fetchRecommnendsTrigger.send()
        viewModel.inputs.fetchPhotosTrigger.send()
    }

    private func setupCollectionView() {

        // MEMO: このレイアウトで利用するセル要素・Header・Footerの登録

        // MainSection: 0
        collectionView.registerCustomCell(BannerCollectionViewCell.self)

        // MainSection: 1
        collectionView.registerCustomCell(RecommendCollectionViewCell.self)
        collectionView.registerCustomReusableHeaderView(RecommendCollectionHeaderView.self)
        
        // MainSection: 2
        collectionView.registerCustomCell(PhotoCollectionViewCell.self)
        collectionView.registerCustomReusableHeaderView(PhotoCollectionHeaderView.self)

        // MEMO: UICollectionViewDelegateについては従来通り
        collectionView.delegate = self

        // MEMO: UICollectionViewCompositionalLayoutを利用してレイアウトを組み立てる
        collectionView.collectionViewLayout = compositionalLayout

        // MEMO: DataSourceはUICollectionViewDiffableDataSourceを利用してUICollectionViewCellを継承したクラスを組み立てる
        dataSource = UICollectionViewDiffableDataSource<PhotoViewControllerSection, AnyHashable>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, model: AnyHashable) -> UICollectionViewCell? in
            
            switch model {

            // MainSection: 0
            case let model as Banner:

                let cell = collectionView.dequeueReusableCustomCell(with: BannerCollectionViewCell.self, indexPath: indexPath)
                cell.setCell(model)
                return cell

            // MainSection: 1
            case let model as Recommend:

                let cell = collectionView.dequeueReusableCustomCell(with: RecommendCollectionViewCell.self, indexPath: indexPath)
                cell.setCell(model)
                return cell

            // MainSection: 2
            case let model as Photo:

                let cell = collectionView.dequeueReusableCustomCell(with: PhotoCollectionViewCell.self, indexPath: indexPath)
                cell.setCell(model)
                return cell

            default:
                return nil
            }
        }

        // MEMO: Header・Footerの表記についてもUICollectionViewDiffableDataSourceを利用して組み立てる
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in

            switch indexPath.section {

            // MainSection: 1
            case PhotoViewControllerSection.recommends.rawValue:
                if kind == UICollectionView.elementKindSectionHeader {
                    let header = collectionView.dequeueReusableCustomHeaderView(with: RecommendCollectionHeaderView.self, indexPath: indexPath)
                    header.setHeader(
                        title: "おすすめ風景集",
                        description: "こちらは作者が実家に帰省した帰り道で撮影した金沢市内出会ったものの写真になります。\n撮影日: 2010年夏頃撮影\n機材:SONY デジタルカメラ DSC-RX100"
                    )
                    return header
                }

            // MainSection: 2
            case PhotoViewControllerSection.photos.rawValue:
                if kind == UICollectionView.elementKindSectionHeader {
                    let header = collectionView.dequeueReusableCustomHeaderView(with: PhotoCollectionHeaderView.self, indexPath: indexPath)
                    header.setHeader(
                        title: "気になる風景フォトグラフ集",
                        description: "個別に気になった風景と簡単な紹介になります。こちらの文章についてはほとんど個人的な主観ではありますが、気になった風景があった場合には是非石川県を旅行した際にはと立ち寄ってみてください。"
                    )
                    return header
                }

            default:
                break
            }
            return nil
        }

        // MEMO: NSDiffableDataSourceSnapshotの初期設定
        snapshot = NSDiffableDataSourceSnapshot<PhotoViewControllerSection, AnyHashable>()
        snapshot.appendSections(PhotoViewControllerSection.allCases)
        for section in PhotoViewControllerSection.allCases {
            snapshot.appendItems([], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func bindToMainViewModelOutputs() {

        // ViewModelのOutputsを経由した特集バナーデータの取得とNSDiffableDataSourceSnapshotの入れ替え処理
        viewModel.outputs.banners
            .subscribe(on: RunLoop.main)
            .sink(
                receiveValue: { [weak self] banners in
                    guard let self = self else { return }
                    self.snapshot.appendItems(banners, toSection: .banners)
                    self.dataSource.apply(self.snapshot, animatingDifferences: false)
                }
            )
            .store(in: &cancellables)

        viewModel.outputs.recommends
            .subscribe(on: RunLoop.main)
            .sink(
                receiveValue: { [weak self] recommends in
                    guard let self = self else { return }
                    self.snapshot.appendItems(recommends, toSection: .recommends)
                    self.dataSource.apply(self.snapshot, animatingDifferences: false)
                }
            )
            .store(in: &cancellables)

        viewModel.outputs.photos
            .subscribe(on: RunLoop.main)
            .sink(
                receiveValue: { [weak self] photos in
                    guard let self = self else { return }
                    self.snapshot.appendItems(photos, toSection: .photos)
                    self.dataSource.apply(self.snapshot, animatingDifferences: false)
                }
            )
            .store(in: &cancellables)
    }

    private func createBannersLayout() -> NSCollectionLayoutSection {

        // 1. Itemのサイズ設定
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero

        // 2. Groupのサイズ設定
        // MEMO: 1列に表示するカラム数を1として設定し、itemのサイズがgroupのサイズで決定する形にしている
        let groupHeight = UIScreen.main.bounds.width * (2 / 3)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(groupHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .zero

        // 3. Sectionのサイズ設定
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        // MEMO: スクロール終了時に水平方向のスクロールが可能で中心位置で止まる
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }

    private func createRecommends() -> NSCollectionLayoutSection {

        // 1. Itemのサイズ設定
        // MEMO: 全体幅2/3の正方形を作るために左側の幅を.fractionalWidth(0.67)に決める
        let twoThirdItemSet = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.67), heightDimension: .fractionalHeight(1.0)))
        twoThirdItemSet.contentInsets = NSDirectionalEdgeInsets(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)
        // MEMO: 右側に全体幅1/3の正方形を2つ作るために高さを.fractionalHeight(0.5)に決める
        let oneThirdItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
        oneThirdItem.contentInsets = NSDirectionalEdgeInsets(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)
        // MEMO: 1列に表示するカラム数を2として設定し、Group内のアイテムの幅を1/3の正方形とするためにGroup内の幅を.fractionalWidth(0.33)に決める
        let oneThirdItemSet = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0)), subitem: oneThirdItem, count: 2)

        // 2. Groupのサイズ設定
        // MEMO: leadingItem(左側へ表示するアイテム1つ)とtrailingGroup(右側へ表示するアイテム2個のグループ1個)を合わせる
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33)), subitems: [twoThirdItemSet, oneThirdItemSet])

        // 3. Sectionのサイズ設定
        let section = NSCollectionLayoutSection(group: group)
        // MEMO: Headerのレイアウトを決定する
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)

        return section
    }

    private func createPhotosLayout() -> NSCollectionLayoutSection {

        // MEMO: 該当のセルを基準にした高さの予測値を設定する
        let estimatedHeight = UIScreen.main.bounds.width + 136.0

        // 1. Itemのサイズ設定
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero

        // 2. Groupのサイズ設定
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .zero

        // 3. Sectionのサイズ設定
        let section = NSCollectionLayoutSection(group: group)
        // MEMO: Headerのレイアウトを決定する
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(86))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 78, trailing: 0)

        return section
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // MEMO: 該当のセクションとIndexPathからNSDiffableDataSourceSnapshot内の該当する値を取得する
        if let targetSection = PhotoViewControllerSection(rawValue: indexPath.section) {
            let targetSnapshot = snapshot.itemIdentifiers(inSection: targetSection)
            print("Section: ", targetSection)
            print("IndexPath.row: ", indexPath.row)
            print("Model: ", targetSnapshot[indexPath.row])
        }
    }
}
