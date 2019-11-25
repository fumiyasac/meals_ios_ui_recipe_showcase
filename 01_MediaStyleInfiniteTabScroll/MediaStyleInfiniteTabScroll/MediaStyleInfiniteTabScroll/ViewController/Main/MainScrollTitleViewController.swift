//
//  MainScrollTitleViewController.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/11/25.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

protocol MainScrollTitleViewControllerDelegate: NSObjectProtocol {

    // 進むボタン・戻るボタンを押下時についての処理
    func moveToPrevIndex(targetDirection: UIPageViewController.NavigationDirection)
    func moveToNextIndex(targetDirection: UIPageViewController.NavigationDirection)
}

final class MainScrollTitleViewController: UIViewController {

    // MARK: - Protocol Variables

    weak var delegate: MainScrollTitleViewControllerDelegate?

    // MARK: - Properties

    // ボタン押下時の軽微な振動を追加する
    private let buttonFeedbackGenerator: UIImpactFeedbackGenerator = {
        let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()

    // MARK: - @IBOutlets

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var prevButton: UIButton!
    @IBOutlet weak private var nextButton: UIButton!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
    }

    // MARK: - Function

    func setTitleFromParent(_ title: String) {
        titleLabel.text = title
    }

    // MARK: - Private Function

    // このViewに配置しているボタンを押下した際に実行される処理（前ページ）
    @objc private func handlePrevButtonTapped(sender: UIButton) {
        self.delegate?.moveToPrevIndex(targetDirection: .reverse)
        buttonFeedbackGenerator.impactOccurred()
    }

    // このViewに配置しているボタンを押下した際に実行される処理（次ページ）
    @objc private func handleNextButtonTapped(sender: UIButton) {
        self.delegate?.moveToNextIndex(targetDirection: .forward)
        buttonFeedbackGenerator.impactOccurred()
    }

    // 進むボタン・戻るボタンに対する初期設定
    private func setupButtons() {
        prevButton.addTarget(self, action:  #selector(self.handlePrevButtonTapped(sender:)), for: .touchUpInside)
        nextButton.addTarget(self, action:  #selector(self.handleNextButtonTapped(sender:)), for: .touchUpInside)
    }
}
