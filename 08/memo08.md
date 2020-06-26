# 第8回

## 関係データベースとXML

- 大量のXMLデータを永続的に管理したい場合，DB管理した方が都合がよい

## XMLとデータベースXMLデータをデータベースに格納するDB

- 方法:
  - XML専用のデータベース(ネイティブデータベース)
  - 関係データベース(今回はこっちを述べる)

## XMLデータの木構造を関係データベースに格納する方法

### エッジアプローチ

- 最も基本的な手法

1. 木で表したXMLデータに対して，各頂点に識別子(ID)を割り当てる．
2. 頂点を格納するテーブルと，辺を格納するテーブルを設け，木の頂点と辺をそれぞれのテーブルに格納

### 範囲ラベリング

- 再帰的なラベル付け手法1

1. 各頂点に対して`(preorder, postorder, level)`というラベルを付与

- preorder
  - 行きがけ順
  - 文書順, 上から読んだ順と同じ
- postorder
  - 帰りがけ順, 再帰的探索
  - 左の葉から順にラベル付け
- level
  - 頂点の深さ(根からの距離)を表す．

2. 頂点のラベルを見ただけで先祖子孫関係が判別できる．

- 先祖子孫関係
  - AがDの先祖⇔`A.preorder<D.preorder`&&`A.postoder>D.postorder`
- 親子関係
  - PがCの親⇔`PがCの先祖`&&`P.level = C.level - 1`⇔`P.preorder<C.preorder`&&`P.postoder>C.postorder`&&`P.level = C.level - 1`

### Deweyオーダ

- 再帰的なラベル付け手法2

1. 木のルートのラベルを`1`とする．
2. ルート以外のノードのラベルを`#{親のラベル}.#{兄弟ノードの順序(何番目の子か)}`とする

- `x章.y節.zセクション.a行目. ...`的な

### 経路アプローチ

- より多くの情報を関係データベースに格納
- 検索時の処理が容易 && 効率化を図ることが可能
- 経路をどうやって使用するかわからん

1. 各要素までの経路を予めテーブルに格納する

- `child`軸や`descendant`軸のみからなるXPath式(その場での相対位置)に対しては，検索処理が容易となる

```json
[
  {
    "PathID": 1,
    "pathname": "/books"
  },
  {
    "PathID": 2,
    "pathname": "/books/book"
  },
  {
    "PathID": 3,
    "pathname": "/books/book/title"
  },
  {
    "PathID": 4,
    "pathname": "/books/book/title/author"
  },
]
```

2. textノード(葉), 各要素(頂点とか)にラベリング

- 例えば`(preorder行きがけ順,postorder帰りがけ順)`で保存

## 現状

- 主な商用RDBは，XMLデータの格納，XPathやXQuery等での検索が可能
  - 例：Oracle, IBM DB2, MS SQLServer
  - オープンソースのDBMSでは，PostgreSQLがXMLDBに対応

## DOM (Document Object Model)

- 元々Web上でHTML文書の構造を表現し，JavaScript等からアクセスするために作成
- W3C(World Wide Web Consortium)によってDOMの標準化作業
- 2000年: DOM Level 2がW3C勧告(W3C Recommendation)
- 2015年: DOM4が[W3C勧告](https://www.w3.org/TR/dom/)
- XMLデータを処理言語から読み込んで処理する時用いる主なAPI
- XML/HTMLをdocumentオブジェクトにDOM木としてパースして処理

### RubyのDOM木探索ライブラリ

- REXML
  - Rubyで記述されたライブラリ
  - Rubyに標準で添付されている．
- libxml
  - C言語で実装(Rubyではラッパーライブラリとしてcall)
  - 別途，インストールが必要
  - 速度はこちらの方が速い

| クラス    | 意味                | 親クラス |
| :-------- | :------------------ | :------- |
| Document  | DOM木のルートノード | Element  |
| Node      | 一般的なノード      |          |
| Element   | 要素ノード          | Parent   |
| Attribute | 属性ノード          | Node     |
| Comment   | コメントノード      | Child    |
| Text      | テキストノード      | Child    |
| Parent    | 親ノード            | Child    |
| Child     | 子ノード            | Node     |

```ruby
# -*- coding: utf-8 -*-

require "rexml/document"

#メソッドtraverseの定義
def traverse(node, order)
  # nodeは探索するノード, orderは初期値

  #文書順と要素名を出力
  printf("%d, %s\n", order, 
node.name)
  order += 1
  # nodeの各子要素を再帰的に探索．得られた文書順をorderに代入
  # ここは
node.erementsが空でバグりそう？
  
node.elements.each{|child|
    order = traverse(child, order)
  }
  #探索後の文書順を返す
  return order
end

def main()
  # XMLデータを読む
  file = File.new("sample.xml")
  # XMLデータをdom木に展開
  doc = REXML::Document.new file
  #文書要素を取得
  root = doc.root
  # DOM木を探索
  traverse(root, 1)
  return 0

exit(main)
```

## 主なメソッド

node => Nodeオブジェクト（要素やテキストを含む一般的なノード）
elm => Elementオブジェクト（要素ノード）
text => Textオブジェクト（テキストノード）
comment => Commentオブジェクト（コメントノード）

| メソッド                   | 意味                                |
| :------------------------- | :---------------------------------- |
| node.parent                | nodeの親ノードを得る                |
| node.name                  | nodeのノード名を得る                |
| node.next_sibling_node     | 次の兄弟ノードを得る                |
| node.previous_sibling_node | 次の兄弟ノードを得る                |
| elm.elements               | elmの子要素を得る(配列)             |
| elm.texts                  | elmの子のテキストノードを得る(配列) |
| elm.comments               | elmの子のコメントノードを得る(配列) |
| elm.has_elements?          | elmが子要素を持つか判定             |
| elm.has_text?              | elmが子のテキストノードを持つか判定 |
| elm.next_element           | elm次の兄弟要素を得る               |
| elm.previous_element       | elm前の兄弟要素を得る               |
| text.value                 | テキストノードの値を得る            |
| comment.string             | コメントの文字列を得る              |

- ノードの種類を調べたい場合nodetypeメソッドを用いる
- 返り値はSymbol

| メソッド     | 意味                      |
| :----------- | :------------------------ |
| elm.nodetype | シンボルelementを返す     |
| comment.node | typeシンボルcommentを返す |
| text.node    | typeシンボルtextを返す    |
