# めも04 EPUB

## フォーマット

電子書籍サイトでもバラバラ

- リフロー系(EPUB, AZW, XMDF, .book)
  - 文字サイズ変更可能
  - 変更すると自動的にリフロー(変更が再読み込み)
  - 文字主体のモノには向いているが漫画には不向き
- 固定レイアウト系(PDF, .ebi.j, KeyringPDF, bookend)
  - 複雑なレイアウトのもの(漫画, 雑誌)向け
  - レイアウト固定なので文字拡大の際にはページ全体の拡大が必要

- XMDF
  - 日本製
  - 1999
  - XML, 規格非公開

- .book
  - 2000
  - 日本製
  - HTML, 規格非公開

- AZW
  - アマゾンKindle
  - 規格非公開
  - HTML, EPUB -> AZWコンバータは公開

- EPUB
  - 2007, 米国IDPF(2016よりW3C)
  - オープンな規格
  - 2011からEPUB3で日本語対応、XML, HTML
  - メタ情報はXML, 表紙や本文はHTML5でzipアーカイブ
  - ルビ, 音声, 動画再生可能
  - 縦書き, 右開きも可能
  - 目次はXHTML

- KeyingPDF, bookending
  - アイドック
  - PDF+DRM

- ebi.j
  - eBookとも
  - イーブックイニシアティブジャパン
  - 画像ベースのフォーマットで文字も画像
  - 漫画向け

- EPUB Fixed Layout
  - 固定レイアウト対応


## EPUB

- minetype
  - ファイルタイプ(EPUBであること)を記述
  - application/epub+zip
- META-INF
  - EPUBのメタ情報を入れるディレクトリ
    - container.XML
      - 最初によまれる
      - OPFファイルの位置を指定

```xml
<?xml version="1.0"?>
<container version="1.0"
 xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
    <rootfiles>
        <rootfile full-path="OEBPS/HelloWorld.opf"
         media-type="application/oebps-package+xml" />
    </rootfiles>
</container>
```

- OEBPS(リネーム可能)
  - 書籍の内容を格納するフォルダ
    - .opf
      - 書籍のメタ情報、各種メディアファイルの一覧
      - package要素
        - 属性に，EPUBのバージョンなどを記載する
          - version: 必須, EPUBのバージョン(3.0or3,1)
          - unique-identifier: 必須, 書籍を識別するための識別子の名前を定義
          - dir: オプション, テキストの方向(ltr(left toright)かrtl(right to left))を指定
          - prefix: オプション, EPUB仕様で規定されていないXML語彙を使用することの宣言
          - xml:lang: オプション, 使用される言語を指定
          - id: オプション, package要素のXML IDを指定
      - metadate要素
        - 書誌情報(本のID，著者など)を記述する
          - dc:identifier: 必須, 書籍を識別するための識別子(値)
            - unique-idenfierで定義された識別子名を用いて指定
          - dc:title: 必須, 書籍のタイトル
          - dc:language: 必須, 使用されている言語
          - meta property="dcterms:modified": 必須, 最終更新日
          - dc:creator: オプション, 書籍の作成者
          - dc:date: オプション, 書籍の発行日
          - dc:publisher: オプション, 書籍の発行元
      - manifest要素
        - 書籍を構成するファイルの一覧を記載する
          - id: 必須, item要素に記載されたファイルのID
          - href: 必須, ファイルの場所(相対URI)
          - media-type: 必須, ファイルのメディアタイプ
          - properties: ファイルの付加的な特徴を属性に記載
            - cover-image: オプション, 表紙画像に対して指定
            - mathml: オプション, MathML数式に対して指定
            - nav: 必須, 目次ファイルに対して指定
            - scripted: オプション, スクリプトを使用するファイルに対して指定
            - svg: オプション, SVGを使用するファイルに対して指定
      - spine要素
        - 書籍のコンテンツ(表紙，目次，本文)の表示順序をitemref要素の出現順で記述する．
        - 特に，本文が複数のHTMLファイルから構成されている場合，その順にitemref要素を記述する．
        - itemrefの属性は:
          - idref: manifest要素内の`<item id>`で指定したファイルのid
          - linear: オプション, 表示されるコンテンツならばyes，そうでない補足的内容ならばno
          - id: オプション, このXML要素の固有のID
      - 表紙, 目次, 本文
        - EPUB3ではXHTML5で記述
        - 本文はCSSが効いていてもよく、複数ファイルでもよい

## EPUB縦書き

1. CSSに以下の記述を追加する．
vertical-rl: 縦書きで行を右から左に
vertical-lr: 縦書きで行を左から右に
horizontal-tb: 横書きで行を上から下に(デフォルト)

```css
html {
    writing-mode:vertical-rl;
    -webkit-writing-mode:vertical-rl;
    -epub-writing-mode:vertical-rl;
}
```

2. OPFファイル(HelloWorld.opf)のspine要素に記述されているpage-progression-directionをrtlに設定する(rtl=rightto left)