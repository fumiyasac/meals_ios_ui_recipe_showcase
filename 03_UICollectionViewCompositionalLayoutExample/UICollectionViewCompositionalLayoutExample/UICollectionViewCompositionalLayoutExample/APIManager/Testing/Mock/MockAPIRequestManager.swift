//
//  MockAPIRequestManager.swift
//  UICollectionViewCompositionalLayoutExample
//
//  Created by 酒井文也 on 2020/12/13.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import Combine

class MockAPIRequestManager {

    // MARK: - Singleton Instance

    static let shared = MockAPIRequestManager()

    private init() {}

    // MARK: - Enum

    private enum FileName: String {
        case banners = "banners"
        case recommends = "recommends"
        case photos = "photo"
        case keywords = "keywords"
    }
}

// MARK: - APIRequestManagerProtocol

extension MockAPIRequestManager: APIRequestManagerProtocol {

    // MARK: - Function

    func getBanners() -> Future<[Banner], APIError> {
        if let path = getStubFilePath(jsonFileName: MockAPIRequestManager.FileName.banners.rawValue) {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            return Future { promise in
                do {
                    let hashableObjects = try JSONDecoder().decode([Banner].self, from: data)
                    promise(.success(hashableObjects))
                } catch {
                    promise(.failure(APIError.error(error.localizedDescription)))
                }
            }
        } else {
            fatalError("Invalid json format or existence of file.")
        }
    }
    
    func getRecommends() -> Future<[Recommend], APIError> {
        if let path = getStubFilePath(jsonFileName: MockAPIRequestManager.FileName.recommends.rawValue) {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            return Future { promise in
                do {
                    let hashableObjects = try JSONDecoder().decode([Recommend].self, from: data)
                    promise(.success(hashableObjects))
                } catch {
                    promise(.failure(APIError.error(error.localizedDescription)))
                }
            }
        } else {
            fatalError("Invalid json format or existence of file.")
        }
    }
    
    func getPhotoList(perPage: Int) -> Future<[PhotoList], APIError> {
        let targetFileName = MockAPIRequestManager.FileName.photos.rawValue + String(perPage)
        if let path = getStubFilePath(jsonFileName: targetFileName) {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            return Future { promise in
                do {
                    let hashableObjects = try JSONDecoder().decode([PhotoList].self, from: data)
                    promise(.success(hashableObjects))
                } catch {
                    promise(.failure(APIError.error(error.localizedDescription)))
                }
            }
        } else {
            fatalError("Invalid json format or existence of file.")
        }
    }
    
    func getKeywords() -> Future<[Keyword], APIError> {
        if let path = getStubFilePath(jsonFileName: MockAPIRequestManager.FileName.keywords.rawValue) {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            return Future { promise in
                do {
                    let hashableObjects = try JSONDecoder().decode([Keyword].self, from: data)
                    promise(.success(hashableObjects))
                } catch {
                    promise(.failure(APIError.error(error.localizedDescription)))
                }
            }
        } else {
            fatalError("Invalid json format or existence of file.")
        }
    }
    
    // MARK: - Private Function

    // プロジェクト内にBundleされているStub用のJSONのファイルパスを取得する
    private func getStubFilePath(jsonFileName: String) -> String? {
        return Bundle.main.path(forResource: jsonFileName, ofType: "json")
    }
}
