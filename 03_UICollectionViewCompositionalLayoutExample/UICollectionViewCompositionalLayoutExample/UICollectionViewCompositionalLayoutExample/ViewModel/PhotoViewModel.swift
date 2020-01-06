//
//  PhotoViewModel.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/05.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import Combine

// MARK: - Protocol (Inputs)

protocol PhotoViewModelInputs {
    var fetchBannersTrigger: PassthroughSubject<Void, Never> { get }
    var fetchRecommnendsTrigger: PassthroughSubject<Void, Never> { get }
    var fetchPhotosTrigger: PassthroughSubject<Void, Never> { get }
    var refreshTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - Protocol (Outputs)

protocol PhotoViewModelOutputs {
    var banners: AnyPublisher<[Banner], Never> { get }
    var recommends: AnyPublisher<[Recommend], Never> { get }
    var photos: AnyPublisher<[Photo], Never> { get }
    var apiRequestStatus: AnyPublisher<APIRequestStatus, Never> { get }
}

// MARK: - Protocol (Types)

protocol PhotoViewModelType {
    var inputs: PhotoViewModelInputs { get }
    var outputs: PhotoViewModelOutputs { get }
}

final class PhotoViewModel: PhotoViewModelType, PhotoViewModelInputs, PhotoViewModelOutputs {

    // MARK: - PhotoViewModelType

    var inputs: PhotoViewModelInputs { return self }
    var outputs: PhotoViewModelOutputs { return self }
    
    // MARK: - PhotoViewModelOutputs

    let fetchBannersTrigger = PassthroughSubject<Void, Never>()
    let fetchRecommnendsTrigger = PassthroughSubject<Void, Never>()
    let fetchPhotosTrigger = PassthroughSubject<Void, Never>()
    let refreshTrigger = PassthroughSubject<Void, Never>()

    // MARK: - MainViewModelOutputs

    var banners: AnyPublisher<[Banner], Never> {
        return $_banners.eraseToAnyPublisher()
    }
    var recommends: AnyPublisher<[Recommend], Never> {
        return $_recommends.eraseToAnyPublisher()
    }
    var photos: AnyPublisher<[Photo], Never> {
        return $_photos.eraseToAnyPublisher()
    }
    var apiRequestStatus: AnyPublisher<APIRequestStatus, Never> {
        return $_apiRequestStatus.eraseToAnyPublisher()
    }
    
    // MARK: - @Published

    // MEMO: ViewModelのOutputへ値を引き渡す際の仲介として利用する
    @Published private var _banners: [Banner] = []
    @Published private var _recommends: [Recommend] = []
    @Published private var _photos: [Photo] = []
    @Published private var _apiRequestStatus: APIRequestStatus = .none

    // MARK: - Property

    private let api: APIRequestManagerProtocol

    private var cancellables: [AnyCancellable] = []
    private var nextPageNumber: Int = 1
    private var hasNextPage: Bool = true
    
    // MARK: - Initializer

    init(api: APIRequestManagerProtocol) {

        // MEMO: 適用するAPIリクエスト用の処理
        self.api = api

        // MEMO: InputTriggerとAPIリクエストをするための処理を結合する
        // → 実行時はViewController側でviewModel.inputs.fetch●●●Trigger.send()で実行する
        fetchBannersTrigger
            .sink(
                receiveValue: { [weak self] _ in
                    self?.fetchBanners()
                }
            )
            .store(in: &cancellables)
        fetchRecommnendsTrigger
            .sink(
                receiveValue: { [weak self] _ in
                    self?.fetchRecommends()
                }
            )
            .store(in: &cancellables)
        fetchPhotosTrigger
            .sink(
                receiveValue: { [weak self] in
                    guard let self = self else { return }

                    // MEMO: 次のページが存在しない場合は以降の処理を実施しないようにする
                    guard self.hasNextPage else {
                        return
                    }
                    self.fetchPhotoLists()
                }
            )
            .store(in: &cancellables)

        // MEMO: 現在まで取得したデータのリフレッシュ処理を伴うAPIリクエスト
        // → 実行時はViewController側でviewModel.inputs.refreshTrigger.send()で実行する
        refreshTrigger
            .sink(
                receiveValue: { [weak self] in
                    guard let self = self else { return }

                    // MEMO: バナー・記事・おすすめセクションにおける表示データのリセット
                    self._banners.removeAll()
                    self.fetchBanners()

                    self._recommends.removeAll()
                    self.fetchRecommends()

                    // MEMO: ページング処理を伴うセクションにおける表示データのリセット
                    self.nextPageNumber = 1
                    self.hasNextPage = true
                    self._photos.removeAll()
                    self.fetchPhotoLists()
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - deinit

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // MARK: - Privete Function

    private func fetchBanners() {
        api.getBanners()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    // MEMO: 値取得成功時
                    case .finished:
                        print("finished api.getBanners(): \(completion)")
                    // MEMO: エラー時
                    case .failure(let error):
                        print("error api.getBanners(): \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] hashableObjects in
                    self?._banners = hashableObjects
                }
            )
            .store(in: &cancellables)
    }

    private func fetchRecommends() {
        api.getRecommends()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    // MEMO: 値取得成功時
                    case .finished:
                        print("finished api.getRecommends(): \(completion)")
                    // MEMO: エラー時
                    case .failure(let error):
                        print("error api.getRecommends(): \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] hashableObjects in
                    self?._recommends = hashableObjects
                }
            )
            .store(in: &cancellables)
    }

    private func fetchPhotoLists() {

        // APIとの通信処理ステータスを「実行中」へ切り替える
        _apiRequestStatus = .requesting

        // APIとの通信処理を実行する
        api.getPhotoList(perPage: nextPageNumber)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    
                    switch completion {
                    // MEMO: 値取得に成功した場合のハンドリング
                    case .finished:
                        // MEMO: APIリクエストの処理結果を成功の状態に更新する
                        self._apiRequestStatus = .requestSuccess
                        print("receiveCompletion api.getPhotoList(perPage: nextPageNumber): \(completion)")
                    // MEMO: 値取得に失敗した場合のハンドリング
                    case .failure(let error):
                        // MEMO: APIリクエストの処理結果を失敗の状態に更新する
                        self._apiRequestStatus = .requestFailure
                        print("receiveCompletion error api.getPhotoList(perPage: nextPageNumber): \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] hashableObjects in
                    guard let self = self else { return }

                    if let photoList = hashableObjects.first {
                        // MEMO: ViewModel内部処理用の変数を更新する
                        self.nextPageNumber = photoList.page + 1
                        self.hasNextPage = photoList.hasNextPage
                        // MEMO: 表示対象データを仲介役の変数へ追加する
                        let newPhotos = photoList.photos
                        let oldPhotos = self._photos
                        self._photos = oldPhotos + newPhotos
                    }
                }
            )
            .store(in: &cancellables)
    }
}
