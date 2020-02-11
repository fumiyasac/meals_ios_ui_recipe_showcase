# iOSアプリ開発 - UI実装であると嬉しいレシピブックまかない編に掲載するサンプル

## 1. 概要

こちらは、上記書籍にて紹介しているサンプルを収録したリポジトリになります。書籍内で解説の際に利用したサンプルコードの完成版のプロジェクトがそれぞれの章毎にありますので、書籍内の解説をより詳細に理解する際や開発中のアプリにおける実装時の参考等にご活用頂ければ嬉しく思います。

 * macOS Catalina 10.15.1
 * Xcode 11.1
 * Swift 5.1
 * CocoaPods 1.8.4

これまでの書籍ではUI実装のアイデアや具体的な手法についてフォーカスを当てた書籍を2冊執筆してきましたが、どうしても誌面の分量の関係等もあって見送ってしまったものもありました。本書では、Vol.1及びVol.2では惜しくも紹介ができなかったUI実装に関する実装解説を「まかない編（番外編）」として簡単でありますがまとめたものになります。また、iOS13以降で新しく登場した新機能を利用して実装したサンプルについても少しだけ触れているものもあります。

これまでの実務の中で培ってきた知識や知見に加えて、一見するととても複雑に見えそうではあれども、実装時の少しの工夫やライブラリの有効活用をすることで実現することができるUI実装に関するサンプルを3点収録しております。

__プロジェクトを動作させるための事前準備:__

サンプルコードでは、ライブラリの管理ツールでCocoaPodsを利用しております。CocoaPodsのインストール方法や基本的な活用方法につきましては下記のリンク等を参考にすると良いかと思います。

+ [初心者向けCocoaPodsの使い方](http://developers.goalist.co.jp/entry/2017/04/20/180931)
+ [CocoaPodsの使い方-入門編](https://www.ukeyslabo.com/development/iosapplication/how-to-use-cocoapods-for-beginner/)
+ [CocoaPodsのPodfileの書き方](https://dev.digitrick.us/notes/podfilesyntax)

## 2. サンプル図解

こちらはの書籍で紹介しているサンプルにおける概略図になります。

### ⭐️第1章サンプル

本章ではメディアアプリをはじめとする読み物系のコンテンツにおけるUI表現においてよく利用されている表現について解説をしていきます。記事一覧画面にて同じ属性の記事が数多く配置しているアプリでは、データ表示部分の上にタブ型のナビゲーションやページネーションをするボタンを配置しているUI表現をしている場合がしばしばあります。また、記事詳細画面についてもUIScrollViewの性質を上手に活用することで、関連した異なる情報を1つの画面に上手にまとめるUI表現は、細部までは配慮しようとすると難易度が上がってしまうUI実装の典型例かもしれません。

実際のアプリで利用されている表現と比べると、少し簡単な構造にしている部分もありますが、こちらのUI実装における勘所をしっかりと理解しておくと重宝する場面もあるかと思います。

![第1章サンプル図](https://github.com/fumiyasac/meals_ios_ui_recipe_showcase/blob/master/images/capture_techbook_meals_chapter1.jpg)

### ️⭐️第2章サンプル

本章ではInstagram等の写真アプリ等でもよく見かける複雑なタイル上のレイアウトをするフォトギャラリーの様なUI表現や、同じカテゴリーに属する表示内容の一覧をタブ型にまとめてスクロールに伴って切り替えるUI表現を組み合わせた、1つの画面の中に多くの情報を整理した形の実装について解説をしていきます。ここで紹介するUIについても、ビジネスサイド等からの要望が高くなりやすい例ではあるものの、実装に際して全て自前で準備する際は大変かつ細部の調整がシビアになりやすいものでもあるかと思います。

メインとなるレイアウト構成や画面構造といった部分に対して、上手にライブラリを活用と取捨選択をすることによって、実装工数の削減やコードの理解がしやすくなる場合もあるので、多くのライブラリとその構造や設計に触れていくとよりUI実装の幅が広がるかと思います。

![第2章サンプル図](https://github.com/fumiyasac/meals_ios_ui_recipe_showcase/blob/master/images/capture_techbook_meals_chapter2.jpg)

__利用しているライブラリ一覧:__

```ruby
target 'MosaicPhotoGalleryLayouts' do
  use_frameworks!
  # Pods for MosaicPhotoGalleryLayouts
  # UI表現の際に利用するライブラリ
  pod 'AnimatedCollectionViewLayout'
  pod 'Blueprints'
  pod 'Parchment'
  pod 'Nantes'
  pod 'PTCardTabBar'
  pod 'TagListView', '~> 1.0'
end
```

__ライブラリのインストール手順:__

```shell
# 今回利用するライブラリのインストール手順
$ cd 02_MosaicPhotoGalleryLayouts/MosaicPhotoGalleryLayouts/ 
$ pod install
```

### ⭐️第3章サンプル

本章ではiOS13から新しく登場した機能の中で、

1. UICollectionViewCompositionalLayout
2. DiffableDataSource
3. Combine Framework

の3つの機能を活用したUI実装について解説をしていきます。
UICollectionViewCompositionalLayoutの登場によって、UICollectionViewにのセクションに応じてレイアウトが異なる構造を持つ画面が従来の方法よりもイメージがしやすい形になり、またこれまではサードパーティー製のライブラリを利用することが多かった差分更新についてもサポートされるようになったことがとても嬉しい変化であると感じています。またCombine Frameworkの登場によってこれまでRxSwiftやReactiveSwiftといったReactive Programmingのためのライブラリで提供されていたような機能も利用できるようになり、UI構築以外の部分における機能についても強化されつつある印象を受けます。

紹介するサンプルのUIについては、一覧を表示するだけの至ってシンプルなものではありますが、先述した3つの新機能を組み合わせて実現している点に注目し、従来の記載方法との違いを見比べて頂けると一層理解が深まるのではないかと思います。
また、モックサーバーAPIへのデータ取得リクエストから画面反映までの処理の流れについても、RxSwift等を利用して実現していた処理を、Combine Frameworkを利用して類似した形にしてみましたので、この部分についても是非RxSwiftでの処理と見比べてみると面白いかもしれません。

![第3章サンプル図](https://github.com/fumiyasac/meals_ios_ui_recipe_showcase/blob/master/images/capture_techbook_meals_chapter3.jpg)

__利用しているライブラリ一覧:__

```ruby
target 'UICollectionViewCompositionalLayoutExample' do
  use_frameworks!
  # Pods for UICollectionViewCompositionalLayoutExample
  # UI表現の際に利用するライブラリ
  pod 'Nuke'
  pod 'BetterSegmentedControl'
end
```

__ライブラリのインストール手順:__

```shell
# 今回利用するライブラリのインストール手順
$ cd 03_UICollectionViewCompositionalLayoutExample/UICollectionViewCompositionalLayoutExample/ 
$ pod install
```

__APIモックサーバーの準備手順:__

本章のサンプルではサンプルアプリ内にAPIモックサーバーから受け取ったJSON形式のレスポンスを画面に表示する処理を実現するために、Node.js製の「JSONServer」というものを利用して実現しています。JSONServerに関する概要や基本的な活用方法につきましては下記のリンク等を参考にすると良いかと思います。

+ [たった30秒でRESTAPIのモックが作れるJSONServerでフロントエンド開発が捗る](https://www.webprofessional.jp/mock-rest-apis-using-json-server/)

```shell
# 1. 必要なパッケージのインストールを実行する
$ cd 03_UICollectionViewCompositionalLayoutExample/server_mock/ 
$ npm install
# 2. モックAPIサーバを起動する(http://localhost:3000/)
$ node index.js
```

## 3. その他サンプルに関することについて

その他、サンプルにおける気になる点や要望等がある場合は是非GithubのIssueやPullRequestをお送り頂けますと嬉しく思います。

__【iOS13 & Xcode11.1へのバージョンアップにおいてこのサンプルで触れていない部分】__

本サンプルでは下記の部分に関しては、今回は対応していませんのでご注意下さい。

+ DarkModeの無効化（現在は強制的にLightModeにしています。）
+ SceneDelegateは利用しない従来のAppDelegateの利用（現状は挙動に問題はありませんが非推奨です。）
