//
//  DetailViewController.swift
//  MediaStyleInfiniteTabScroll
//
//  Created by 酒井文也 on 2019/10/28.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

// MEMO: InterfaceBuilderに配置したUIScrollViewにおいては「Content Layout Guide」のチェックを外す
// https://stackoverflow.com/questions/56570660/how-to-fix-scrollable-content-size-ambiguity-in-xcode-11-ios-12-ios-13-usin

final class DetailViewController: UIViewController {

    // MARK: - Properties

    // ヘッダー部分の表示エリアのトータルの高さ
    private let headerHeight: CGFloat = 300.0

    // DetailSwitchButtonsViewの高さ
    private let tabHeight: CGFloat = 40.0

    // UITableViewで表示する対象のデータ
    // → 今回はStaticなダミーデータの表示なのでこの形にしている
    private let detailInformation: [ArticleInformationEntity] = ArticleDetailModel.getSampleInformation()
    private let detailComments: [ArticleCommentEntity] = ArticleDetailModel.getSampleComments()

    // UITableViewで表示するものをひとまとめにするための変数
    private var tableViews: [UITableView] = []
    
    // MARK: - @IBOutlets

    // ヘッダー部分の写真パララックス表現をするViewにおける上方向の制約値
    @IBOutlet weak private var headerViewTopConstraint: NSLayoutConstraint!

    // コンテンツ表示エリアのUITableView × 2を内包するUIScrollView
    @IBOutlet weak private var detailScrollView: UIScrollView!

    // ヘッダー部分の写真パララックス表現をするView
    @IBOutlet weak private var detailHeaderView: DetailHeaderView!

    // ヘッダー部分のコンテンツ表示切り替えを表現をするView
    @IBOutlet weak private var detailSwitchButtonsView: DetailSwitchButtonsView!

    // UIScrollView内で表示するUITableView × 2
    @IBOutlet weak private var detailInformationTableView: UITableView!
    @IBOutlet weak private var detailCommentTableView: UITableView!    

    // セミモーダル表示用ボタン
    @IBOutlet weak private var semiModalButton: UIButton!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("ご覧頂きありがとうございます！")
        setupDetailScrollView()
        setupDetailHeaderView()
        setupDetailSwitchButtonsView()
        setupTableViewsInDetailScrollView()
        setupSemiModalButton()
    }

    // MARK: - Private Function

    @objc private func handleSemiModalButtonTapped(sender: UIButton) {

        // MEMO: この場合はModalの遷移ではあるが、iOS13以降とそれ以前でのPresent/Dismiss時の調整は不要
        // → ModalPresentetionStyleの調整をSemiModalViewControllerの初期化時に実行しているため
        let sb = UIStoryboard(name: "SemiModal", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! SemiModalViewController
        self.present(vc, animated: true, completion: nil)
    }

    private func setupDetailScrollView() {

        // MEMO: NavigationBar分のスクロール位置がずれてしまうのでその考慮を行う
        if #available(iOS 11.0, *) {
            detailScrollView.contentInsetAdjustmentBehavior = .never
        }
        detailScrollView.delegate = self
        detailScrollView.isPagingEnabled = true
        detailScrollView.showsHorizontalScrollIndicator = false
    }

    private func setupDetailHeaderView() {

        // MEMO: 画像を表示すると同時にスクロール可能にするためにタッチイベントを無効にする
        detailHeaderView.isUserInteractionEnabled = false
        detailHeaderView.setHeaderImage(UIImage.init(named: "header"))
    }

    private func setupDetailSwitchButtonsView() {

        // MEMO: DetailSwitchButtonsViewクラスに定義したプロトコルを適用する
        detailSwitchButtonsView.delegate = self
    }

    private func setupTableViewsInDetailScrollView() {

        // MEMO: detailInformationTableView・detailCommentTableViewの初期設定
        detailInformationTableView.registerCustomCell(DetailInformationTableViewCell.self)
        detailCommentTableView.registerCustomCell(DetailCommentTableViewCell.self)

        tableViews = [detailInformationTableView, detailCommentTableView]
        let _ = tableViews.map { tableView in
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 72.0, right: 0)
            tableView.reloadData()
        }
    }

    private func setupSemiModalButton() {

        // セミモーダル表示用ボタンの初期設定
        semiModalButton.addTarget(self, action:  #selector(self.handleSemiModalButtonTapped(sender:)), for: .touchUpInside)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == detailInformationTableView {
            return detailInformation.count
        }
        if tableView == detailCommentTableView {
            return detailComments.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == detailInformationTableView {
            let cell = tableView.dequeueReusableCustomCell(with: DetailInformationTableViewCell.self)
            cell.setCell(detailInformation[indexPath.row])
            return cell
        }
        if tableView == detailCommentTableView {
            let cell = tableView.dequeueReusableCustomCell(with: DetailCommentTableViewCell.self)
            cell.setCell(detailComments[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UIScrollViewDelegate

extension DetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // MEMO: 表示コンテンツ（UITableView × 2）を配置するUIScrollViewが水平方向のスクロールをした場合の処理
        if scrollView == detailScrollView {

            // MEMO: DetailSwitchButtonsViewに配置した下線の位置にボタン表示の変更をする
            detailSwitchButtonsView.updateSelectedBarPositionBy(scrollViewOffsetX: scrollView.contentOffset.x)

            // MEMO: 水平方向のスクロール時は以降の処理を実施しない
            return
        }

        // MEMO: 画像のパララックス効果付きのViewに付与されているAutoLayout制約を変更してパララックス効果を出す
        detailHeaderView.setParallaxEffectToHeaderView(scrollView)

        // MEMO: ヘッダーに表示しているView要素においてタブ切り替えのボタンエリアが表示され続けるようにする
        // → ヘッダー全体は300pxの高さを確保して下記のような配置関係にしている
        // ・上から260px: 画像のパララックス効果付きのView
        // ・残り40px: コンテンツ切り替えボタンを配置したView
        let headerViewLimitConstraint = -headerHeight + tabHeight
        let headerViewCurrentConstraint = -(scrollView.contentOffset.y + headerHeight)
        headerViewTopConstraint.constant = max(headerViewCurrentConstraint, headerViewLimitConstraint)

        // Case1: 画像のパララックス効果付きのViewが見えている場合
        if scrollView.contentOffset.y <= -tabHeight {

            // MEMO: 配置した各UITableViewのY軸方向のオフセット値も一緒に更新する
            let _ = tableViews.map { tableView in
                tableView.contentOffset.y = scrollView.contentOffset.y
            }

        // Case2: 画像のパララックス効果付きのViewが完全に隠れている場合
        } else {

            // MEMO: 現在動かしていないUITableViewのトップ位置を調整する
            let _ = tableViews.map { tableView in
                if tableView.contentOffset.y < -tabHeight {
                     tableView.contentOffset.y = -tabHeight
                }
            }
        }

        // MEMO: このサンプル内で組み込んでいないがNavigationBarの色や文字色をスクロールを伴って変更させる場合
        /*
        基本的な実装方針の参考: https://www.youtube.com/watch?v=rNy6aQQYbuY
        ① UINavigationBarに関する初期設定
        '''
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        '''
        ※1) 前後のUINavigationControllerとの兼ね合いで遷移元に影響が出ない様に注意する
        ※2) StatusBar部分にも色を付ける場合にはiOS13の対応が必要
        https://freakycoder.com/ios-notes-13-how-to-change-status-bar-color-1431c185e845

        ② scrollViewDidScroll内で実行する処理
        '''
        var offset = ...（scrollView.contentOffset.yの値を利用して割合を算出する）...
        if offset < 0 {
            offset = 0
        } else if offset > 1 {
            offset = 1
        }
        let color = UIColor.init(code: "#ff6600", alpha: offset)
        self.navigationController?.navigationBar.tintColor = UIColor.init(hue: 1, saturation: offset, brightness: 1, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = color
        '''
        */
    }
}

// MARK: - DetailSwitchButtonsViewDelegate

extension DetailViewController: DetailSwitchButtonsViewDelegate {

    // 配置しているUIScrollViewのX軸方向のオフセット値を変更するアニメーションを実施する
    // → 処理をつなげるためのプロトコルはDetailSwitchButtonsViewに定義
    func moveDetailScrollViewHorizontally(selectedButtonTag: Int) {

        // MEMO: 押下されたボタンに設定したタグ値を利用してX軸方向のオフセット値を変更する
        let newOffsetX = detailScrollView.frame.width * CGFloat(selectedButtonTag)
        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseInOut], animations: {
            self.detailScrollView.contentOffset = CGPoint(x: newOffsetX, y: 0)
        }, completion: nil)
    }
}
