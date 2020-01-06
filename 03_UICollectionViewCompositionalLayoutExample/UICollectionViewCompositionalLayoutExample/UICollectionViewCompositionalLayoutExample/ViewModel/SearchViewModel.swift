//
//  SearchViewModel.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/05.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import Combine

// MARK: - Protocol (Inputs)

protocol SearchViewModelInputs {
    var fetchKeywordTrigger: PassthroughSubject<Void, Never> { get }
    var refreshTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - Protocol (Outputs)

protocol SearchViewModelOutputs {
    var keywords: AnyPublisher<[Keyword], Never> { get }
    var apiRequestStatus: AnyPublisher<APIRequestStatus, Never> { get }
}

// MARK: - Protocol (Types)

protocol SearchViewModelType {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}

final class SearchViewModel: SearchViewModelType, SearchViewModelInputs, SearchViewModelOutputs {

    // MARK: - SearchViewModelType

    var inputs: SearchViewModelInputs { return self }
    var outputs: SearchViewModelOutputs { return self }

    // MARK: - SearchViewModelInputs

    let fetchKeywordTrigger = PassthroughSubject<Void, Never>()
    let refreshTrigger = PassthroughSubject<Void, Never>()
    
    // MARK: - SearchViewModelOutputs

    var keywords: AnyPublisher<[Keyword], Never> {
        return $_keywords.eraseToAnyPublisher()
    }
    var apiRequestStatus: AnyPublisher<APIRequestStatus, Never> {
        return $_apiRequestStatus.eraseToAnyPublisher()
    }

    // MARK: - @Published

    // MEMO: ViewModelのOutputへ値を引き渡す際の仲介として利用する
    @Published private var _keywords: [Keyword] = []
    @Published private var _apiRequestStatus: APIRequestStatus = .none

    // MARK: - Property

    private let api: APIRequestManagerProtocol

    private var cancellables: [AnyCancellable] = []

    // MARK: - Initializer

    init(api: APIRequestManagerProtocol) {

        // MEMO: 適用するAPIリクエスト用の処理
        self.api = api

        // MEMO: InputTriggerとAPIリクエストをするための処理を結合する
        // → 実行時はViewController側でviewModel.inputs.fetch●●●Trigger.send()で実行する
        fetchKeywordTrigger
            .sink(
                receiveValue: { [weak self] _ in
                    self?.fetchKeywords()
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
                    self._keywords.removeAll()
                    self.fetchKeywords()
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - deinit

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // MARK: - Privete Function

    private func fetchKeywords() {

        // APIとの通信処理ステータスを「実行中」へ切り替える
        _apiRequestStatus = .requesting

        // APIとの通信処理を実行する
        api.getKeywords()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in

                    switch completion {
                    // MEMO: 値取得成功時
                    case .finished:
                        // MEMO: APIリクエストの処理結果を成功の状態に更新する
                        self?._apiRequestStatus = .requestSuccess
                        print("finished api.getKeywords(): \(completion)")
                    // MEMO: エラー時
                    case .failure(let error):
                        // MEMO: APIリクエストの処理結果を失敗の状態に更新する
                        self?._apiRequestStatus = .requestFailure
                        print("error api.getKeywords(): \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] hashableObjects in
                    self?._keywords = hashableObjects
                }
            )
            .store(in: &cancellables)
    }
}
