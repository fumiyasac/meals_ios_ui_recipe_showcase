//
//  AppDelegate.swift
//  MosaicPhotoGalleryLayouts
//
//  Created by 酒井文也 on 2019/10/28.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MEMO: DarkModeのキャンセル対応
    // → Info.plist内で「User Interface Style」を「Light」に設定する
    // (参考) https://stackoverflow.com/questions/56537855/is-it-possible-to-opt-out-of-dark-mode-on-ios-13

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MEMO: iOS15に関する配色に関する調整対応
        setupNavigationBarAppearance()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

    // MARK: - Private Function

    private func setupNavigationBarAppearance() {

        // iOS15以降ではUINavigationBarの配色指定方法が変化する点に注意する
        // https://shtnkgm.com/blog/2021-08-18-ios15.html
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()

            // MEMO: UINavigationBar内部におけるタイトル文字の装飾設定
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.font : UIFont(name: "HiraKakuProN-W6", size: 12.0)!,
                NSAttributedString.Key.foregroundColor : UIColor.black
            ]

            // MEMO: UINavigationBar背景色の装飾設定
            navigationBarAppearance.backgroundColor = UIColor.clear

            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
}
