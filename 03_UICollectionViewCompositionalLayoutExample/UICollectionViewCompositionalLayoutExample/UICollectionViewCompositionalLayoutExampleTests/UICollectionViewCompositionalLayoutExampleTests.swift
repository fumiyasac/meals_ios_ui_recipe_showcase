//
//  UICollectionViewCompositionalLayoutExampleTests.swift
//  UICollectionViewCompositionalLayoutExampleTests
//
//  Created by 酒井文也 on 2019/12/31.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import XCTest
import Combine

@testable import UICollectionViewCompositionalLayoutExample

class UICollectionViewCompositionalLayoutExampleTests: XCTestCase {

    private let photoViewModel: PhotoViewModel = PhotoViewModel(api: MockAPIRequestManager.shared)
    private let searchViewModel: SearchViewModel = SearchViewModel(api: MockAPIRequestManager.shared)
    private var cancellables: [AnyCancellable] = []

    override func setUp() {}

    override func tearDown() {}

    // MARK: - Function

    // Case1: PhotoViewModelにおけるデータの取得処理に関するテスト
    func testPhotoViewModel() {

        // バナーデータの取得処理に関するテスト
        executeFetchBannersTest(photoViewModel: photoViewModel)
        // おすすめデータの取得処理に関するテスト
        executeFetchRecommendsTest(photoViewModel: photoViewModel)
        // フォトデータの取得処理に関するテスト
        executeFetchPhotosTest(photoViewModel: photoViewModel)
    }

    // Case1-1: PhotoViewModelにおけるバナーデータの取得処理に関するテスト
    private func executeFetchBannersTest(photoViewModel: PhotoViewModel) {

        // ViewModelのOutputから取得できたデータを格納するための変数
        var receivedBanners: [Banner] = []
        // サブスレッドでViewModelのInputを実行する
        let expectation: XCTestExpectation? = self.expectation(description: "fetchBannersTest")
        DispatchQueue.global().async {
            photoViewModel.inputs.fetchBannersTrigger.send()
            DispatchQueue.main.async {
                expectation?.fulfill()
            }
        }
        // ViewModelのOutputから取得できたデータを格納する処理
        photoViewModel.outputs.banners
            .subscribe(on: RunLoop.main)
            .sink(
                receiveValue: { banners in
                    receivedBanners = banners
                }
            )
            .store(in: &cancellables)
        // ViewModelのOutputより取得できた値に関するテスト
        waitForExpectations(timeout: 1.0, handler: { _ in
            let receivedBannersCount = receivedBanners.count
            XCTAssertEqual(3, receivedBannersCount, "バナーデータは合計3件取得できること")
            let firstData = receivedBanners.first
            XCTAssertEqual(1, firstData?.id, "1番目のidが正しい値であること")
            XCTAssertEqual("金沢の歴史的文化遺産と秋の風景", firstData?.title, "1番目のtitleが正しい値であること")
        })
    }

    // Case1-2: PhotoViewModelにおけるおすすめデータの取得処理に関するテスト
    private func executeFetchRecommendsTest(photoViewModel: PhotoViewModel) {

        // ViewModelのOutputから取得できたデータを格納するための変数
        var receivedRecommends: [Recommend] = []

        // サブスレッドでViewModelのInputを実行する
        let expectation: XCTestExpectation? = self.expectation(description: "fetchRecommendsTest")
        DispatchQueue.global().async {
            photoViewModel.inputs.fetchRecommnendsTrigger.send()
            DispatchQueue.main.async {
                expectation?.fulfill()
            }
        }

        // ViewModelのOutputから取得できたデータを格納する処理
        photoViewModel.outputs.recommends
            .subscribe(on: RunLoop.main)
            .sink(
                receiveValue: { recommends in
                    receivedRecommends = recommends
                }
            )
            .store(in: &cancellables)

        // ViewModelのOutputより取得できた値に関するテスト
        waitForExpectations(timeout: 1.0, handler: { _ in
            let receivedRecommendsCount = receivedRecommends.count
            XCTAssertEqual(12, receivedRecommendsCount, "おすすめデータは合計12件取得できること")
            let firstData = receivedRecommends.first
            XCTAssertEqual(1, firstData?.id, "1番目のidが正しい値であること")
            XCTAssertEqual("No.1(魚市場)", firstData?.title, "1番目のtitleが正しい値であること")
            XCTAssertEqual("食彩", firstData?.category, "1番目のcategoryが正しい値であること")
        })
    }

    // Case1-3: PhotoViewModelにおけるフォトデータの取得処理に関するテスト
    private func executeFetchPhotosTest(photoViewModel: PhotoViewModel) {

        // ViewModelのOutputから取得できたデータを格納するための変数
        var receivedPhotos: [Photo] = []
        var pageCount: Int = 0
        
        for i in 1...3 {
            // カウント用の値を変数へ格納する
            pageCount = i

            // サブスレッドでViewModelのInputを実行する
            let expectation: XCTestExpectation? = self.expectation(description: "fetchPhotosTest\(i)")
            DispatchQueue.global().async {
                photoViewModel.inputs.fetchPhotosTrigger.send()
                DispatchQueue.main.async {
                    expectation?.fulfill()
                }
            }
        }

        // ViewModelのOutputから取得できたデータを格納する処理
        photoViewModel.outputs.photos
            .subscribe(on: RunLoop.main)
            .sink(
                receiveValue: { photos in
                    receivedPhotos = photos
                }
            )
            .store(in: &cancellables)

        // ViewModelのOutputより取得できた値に関するテスト
        waitForExpectations(timeout: 1.0, handler: { _ in
            let expectedPhotosCount = 5 * pageCount
            let receivedPhotosCount = receivedPhotos.count
            XCTAssertEqual(expectedPhotosCount, receivedPhotosCount, "取得できたフォトデータの総数(5,10,15)が期待するものと一致すること")
        })
    }

    // Case2: SearchViewModelにおけるデータの取得処理に関するテスト
    func testSearchViewModel() {

        // キーワードデータの取得処理に関するテスト
        executeFetchKeywordsTest(searchViewModel: searchViewModel)
    }

    // Case2-1: SearchViewModelにおけるおすすめデータの取得処理に関するテスト
    private func executeFetchKeywordsTest(searchViewModel: SearchViewModel) {

        // ViewModelのOutputから取得できたデータを格納するための変数
        var receivedKeywords: [Keyword] = []

        // サブスレッドでViewModelのInputを実行する
        let expectation: XCTestExpectation? = self.expectation(description: "fetchKeywordsTest")
        DispatchQueue.global().async {
            searchViewModel.inputs.fetchKeywordTrigger.send()
            DispatchQueue.main.async {
                expectation?.fulfill()
            }
        }

        // ViewModelのOutputから取得できたデータを格納する処理
        searchViewModel.outputs.keywords
            .subscribe(on: RunLoop.main)
            .sink(
                receiveValue: { keywords in
                    receivedKeywords = keywords
                }
            )
            .store(in: &cancellables)

        // ViewModelのOutputより取得できた値に関するテスト
        waitForExpectations(timeout: 1.0, handler: { _ in
            let receivedKeywordsCount = receivedKeywords.count
            XCTAssertEqual(15, receivedKeywordsCount, "キーワードデータは合計15件取得できること")
            let firstData = receivedKeywords.first
            XCTAssertEqual(1, firstData?.id, "1番目のidが正しい値であること")
            XCTAssertEqual("倶利伽羅峠", firstData?.keyword, "1番目のkeywordが正しい値であること")
            XCTAssertEqual("くりからとうげ", firstData?.kana, "1番目のkanaが正しい値であること")
        })
    }
}
