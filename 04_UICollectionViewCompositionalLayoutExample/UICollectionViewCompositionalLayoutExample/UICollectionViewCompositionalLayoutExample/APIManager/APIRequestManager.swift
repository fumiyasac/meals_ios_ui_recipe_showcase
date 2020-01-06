//
//  APIRequestManager.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/01/05.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import Combine

// MARK: - Enum

// APIリクエスト状態定義に関するEnum
enum APIRequestStatus {
    case none
    case requesting
    case requestSuccess
    case requestFailure
}

// APIエラーに関するEnum
enum APIError : Error {
    case error(String)
}

// MARK: - Protocol

protocol APIRequestManagerProtocol {
    func getBanners() -> Future<[Banner], APIError>
    func getRecommends() -> Future<[Recommend], APIError>
    func getPhotoList(perPage: Int) -> Future<[PhotoList], APIError>
    func getKeywords() -> Future<[Keyword], APIError>
}

class APIRequestManager {

    // MEMO: MockサーバーへのURLに関する情報
    private static let host = "http://localhost:3000/api/mock"
    private static let version = "v1"
    private static let path = "special"

    private let session = URLSession.shared

    // MARK: - Singleton Instance

    static let shared = APIRequestManager()

    private init() {}

    // MARK: - Enum

    private enum EndPoint: String {

        case banners = "banners"
        case recommends = "recommends"
        case photos = "photos"
        case keywords = "keywords"

        func getBaseUrl() -> String {
            return [host, version, path, self.rawValue].joined(separator: "/")
        }
    }
}

// MARK: - APIRequestManagerProtocol

extension APIRequestManager: APIRequestManagerProtocol {

    // MARK: - Function

    func getBanners() -> Future<[Banner], APIError> {
        let bannersAPIRequest = makeUrlForGetRequest(EndPoint.banners.getBaseUrl())
        return handleSessionTask(Banner.self, request: bannersAPIRequest)
    }

    func getRecommends() -> Future<[Recommend], APIError> {
        let recommendsAPIRequest = makeUrlForGetRequest(EndPoint.recommends.getBaseUrl())
        return handleSessionTask(Recommend.self, request: recommendsAPIRequest)
    }

    func getPhotoList(perPage: Int) -> Future<[PhotoList], APIError> {
        let endPointUrl = EndPoint.photos.getBaseUrl() + "?page=" + String(perPage)
        let photoListAPIRequest = makeUrlForGetRequest(endPointUrl)
        return handleSessionTask(PhotoList.self, request: photoListAPIRequest)
    }

    func getKeywords() -> Future<[Keyword], APIError> {
        let keywordsAPIRequest = makeUrlForGetRequest(EndPoint.keywords.getBaseUrl())
        return handleSessionTask(Keyword.self, request: keywordsAPIRequest)
    }

    // MARK: - Private Function

    // Future型を利用した利用して成功 or 失敗のイベントを1度だけ流す処理内にAPIリクエストを実行する処理をまとめる
    private func handleSessionTask<T: Decodable & Hashable>(_ dataType: T.Type, request: URLRequest) -> Future<[T], APIError> {
        return Future { promise in

            let task = self.session.dataTask(with: request) { data, response, error in
                // MEMO: レスポンス形式やステータスコードを元にしたエラーハンドリングをする
                if let error = error {
                    promise(.failure(APIError.error(error.localizedDescription)))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    promise(.failure(APIError.error("Error: invalid HTTP response code")))
                    return
                }
                guard let data = data else {
                    promise(.failure(APIError.error("Error: missing response data")))
                    return
                }
                // MEMO: 取得できたレスポンスを引数で指定した型の配列に変換して受け取る
                do {
                    let hashableObjects = try JSONDecoder().decode([T].self, from: data)
                    promise(.success(hashableObjects))
                } catch {
                    promise(.failure(APIError.error(error.localizedDescription)))
                }
            }
            task.resume()
        }
    }

    // APIモックサーバーへのGETリクエストを作成する
    private func makeUrlForGetRequest(_ urlString: String) -> URLRequest {
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
