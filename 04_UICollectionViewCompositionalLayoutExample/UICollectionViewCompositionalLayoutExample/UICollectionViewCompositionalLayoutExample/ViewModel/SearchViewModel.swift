//
//  SearchViewModel.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/05.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import Combine

protocol SearchViewModelInputs {
    var fetchKeywordTrigger: PassthroughSubject<Void, Never> { get }
}

protocol SearchViewModelOutputs {
    var keywords: AnyPublisher<[Keyword], Never> { get }
}

protocol SearchViewModelType {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}

final class SearchViewModel: SearchViewModelType, SearchViewModelInputs, SearchViewModelOutputs {

    // MARK: - SearchViewModelType

    var inputs: SearchViewModelInputs { return self }
    var outputs: SearchViewModelOutputs { return self }

    // MARK: - PhotoViewModelInputs

    let fetchKeywordTrigger = PassthroughSubject<Void, Never>()

    // MARK: - MainViewModelOutputs

    var keywords: AnyPublisher<[Keyword], Never> {
        return $_keywords.eraseToAnyPublisher()
    }

    // MARK: - @Published

    // MEMO: ViewModelのOutputへ値を引き渡す際の仲介として利用する
    @Published private var _keywords: [Keyword] = []

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
    }

    // MARK: - deinit

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // MARK: - Privete Function

    private func fetchKeywords() {
        api.getKeywords()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    // MEMO: 値取得成功時
                    case .finished:
                        print("finished api.getKeywords(): \(completion)")
                    // MEMO: エラー時
                    case .failure(let error):
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
