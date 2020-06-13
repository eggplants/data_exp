# 第五回メモ

## RDF

- 特定のアプリや知識領域を前提とせず互換性がある形でリーソースを記述する枠組み。
- 主語(subject)/述語(predicate)/目的語(object)の三つ組みで文(statement)を記述
- 三つ組み=RDFトリプル
- 「Subjectのobjectはpredicateである。」
- データの中でも:
  - リテラル
    - 文字列や数値
    - 主語や述語に成れない
    - 四角で表す
    - 一意でなくてもよいもの
- 主語が匿名である(文字として記載できない)場合は空白ノード
- RDFにおいてノードには概念を一意に指し示す識別子URIを与える

## URI

- URL + URN
  - URL(Uniform Resource Locator)
    - アクセスの際のプロトコルや場所
    - スキーム://ホスト名/リソースの場所
  - URN(Uniform Resource Name)
    - プロトコルに依存しないパラメータの種名
    - urn:名前空間識別子:リソース識別子
      - urn:isbn:4-8399-0454-5
      - urn:ietf:rfc:2141
      - URN:pin:bs4321234

## RDF/XML

- RDFの実際用いる際の形式

### 例

- `urn:pin:BL608`の`http://www.w3.org/People/Berners-Lee/`は`ex:hasHomePage`だ

```xml
<rdf:Description rdf:about="urn:pin:BL608">
  <ex:hasHomePage>
    <rdf:Description rdf:about="http://www.w3.org/People/Berners-Lee/" />
  </ex:hasHomePage>
</rdf:Description>
```

- `urn:pin:BL608`の`[Tim Berners-Lee]`は`dc:creator`だ。

```xml
<rdf:Description rdf:about="urn:pin:BL608">
  <dc:creator>Tim Berners-Lee</dc:creator>
</rdf:Description>
```

- `urn:pin:BL608`の:
  - `http://www.w3.org/People/Berners-Lee/`は`ex:hasHomePage`だ
  - `[Tim Berners-Lee]`は`ex:name`だ。

```xml
<rdf:Description rdf:about="urn:pin:BL608">
  <ex:name>Tim Berners-Lee</ex:name>
  <ex:hasHomePage>
    <rdf:Description rdf:about="http://www.w3.org/People/Berners-Lee/" />
  </ex:hasHomePage>
</rdf:Description>
```

- `urn:pin:BL608`の`http://www.w3.org/People/Berners-Lee/`は`ex:hasHomePage`だ。
  - `http://www.w3.org/People/Berners-Lee/`の`http://www.w3.org/People/Berners-Lee/TBL_Disclaimer.html`は`ex:disclaimer`だ。

```xml
<rdf:Description rdf:about="urn:pin:BL608">
    <ex:hasHomePage>
        <rdf:Description rdf:about="http://www.w3.org/People/Berners-Lee/">
            <ex:disclaimer>
                <rdf:Description rdf:about="http://www.w3.org/People/Berners-Lee/TBL_Disclaimer.html" />
            </ex:disclaimer>
        </rdf:Description>
    </ex:hasHomePage>
</rdf:Description>
```

- 上記を別々に書くと…

```xml
<rdf:Description rdf:about="urn:pin:BL608">
    <ex:hasHomePage>
        <rdf:Description rdf:about="http://www.w3.org/ People/Berners-Lee/" />
    </ex:hasHomePage>
</rdf:Description>

<rdf:Description rdf:about="http://www.w3.org/People/Berners-Lee/">
    <ex:disclaimer>
        <rdf:Description rdf:about="http://www.w3.org/People/Berners-Lee/TBL_Disclaimer.html" />
    </ex:disclaimer>
</rdf:Description>
```

- `http://www.w3.org/People/Berners-Lee/`の`()`は`dc:creator`だ
  - `()`の:
    - `[Tim Berners-Lee]`は`ex:name`だ
    - `mailto:timbl@w3.org`は`ex:email`だ

```xml
<rdf:Description rdf:about="http://www.w3.org/People/Berners-Lee/">
  <dc:creator>
    <rdf:Description>
      <ex:name>Tim Berners-Lee</ex:name>
      <ex:email>
        <rdf:Description rdf:about="mailto:timbl@w3.org" />
      </ex:email>
    </rdf:Description>
  </dc:creator>
</rdf:Description>
```

- 省略構文
- `urn:pin:BL608`の`http://www.w3.org/People/Berners-Lee`は`ex:hasHomePage`だ

```xml
<!--rdf:resourceは，述語の要素において，目的語となるリソースのURIを指定するための属性-->
<rdf:Description rdf:about="urn:pin:BL608">  
  <ex:hasHomePage rdf:resource="http://www.w3.org/People/Berners-Lee/" />
</rdf:Description>
```

- 一方，省略構文を使わない場合は次のようになる．

```xml
<!--この場合，rdf:resourceではなく，rdf:about-->
<rdf:Description rdf:about="urn:pin:BL608">
  <ex:hasHomePage>
    <rdf:Description rdf:about="http://www.w3.org/People/Berners-Lee/" />
  </ex:hasHomePage>
</rdf:Description>
```

- 目的語がリテラルの場合は，述語を主語ノード要素の属性とし，目的語をその属性値として表す．

- `urn:pin:BL608`の`[Tim Berners-Lee]`は`dc:creator`だ

```xml
<rdf:Description rdf:about="urn:pin:BL608" dc:creator="Tim Berners-Lee" />
```

- `urn:pin:BL608`の`http://www.w3.org/People/Berners-Lee/`は`ex:hasHomePage`だ
  - `http://www.w3.org/People/Berners-Lee/`の`2008/4/23`は`ex:created`だ

```xml
<rdf:Description rdf:about="urn:pin:BL608">
  <ex:hasHomePage rdf:resource="http://www.w3.org/People/Berners-Lee/"ex:created="2008/4/23" />
</rdf:Description>
```

## ダブリンコア

- 1995年オハイオ州ダブリンでのメタデータのワークショップ
  - Web上のリソースのメタデータを記述する語彙として開発
- 述語の語彙の統一性担保

### ダブリン・コアの基本15要素

- `dc:xxx`
- DC Metadata Element Set, DCMES
- http://purl.org/dc/elements/1.1/


| 要素名 | 説明 |
|:-------|:------|
| title | タイトル．リソースに与えられた名前 |
|creator|リソースの内容に主たる責任を持つ人や組織など，作成者|
|subject|テーマ，トピック。通常、主題を示すキーワードやキーになるフレーズ、分類コードなど|
|description|説明。要約、目次、文書の内容を表現した画像への参照、あるいは自由形式の説明文など|
|publisher|提供者．このリソースを利用可能にしている実体の責任表記。個人の場合もあれば、組織やサービスの場合もある。|
|contributor|協力者．リソースの内容に寄与している人や組織、サービスなど．|
|date|日付．リソースのライフサイクルにおける出来事に関連する時や期間|
|type|タイプ．性質もしくはジャンル．一般的なカテゴリ、機能、分野、内容の集約度などを示す用語を用いる。|
|format|フォーマット．物理的あるいはデジタル化の形態．主として、メディアタイプや量（サイズ）を示す|
|identifier|曖昧さのない参照，識別子|
|source|派生元リソースへの参照|
|language|言語。言語コードを使うことが推奨される。|
|relation|関連するリソースへの参照|
|coverage|範囲もしくは対象。場所（地名、緯度経度）、時間区分（時代、日付、期間）、管轄区分（管理責任者名）などの分類を記述する。|
|rights|権利に関する情報。通常、リソースの知的所有権、著作権、財産権などについての言明を含む。|

### 拡張プロパティ

- DC基本要素を拡張して，より詳細な定義を可能にする精密化要素
- `dcterms:xxx`
- http://purl.org/dc/terms/


| 基本要素     | 拡張プロパティ   | 説明                |
|:------------|:----------------|:-------------------|
| title       | alternative     | 正式なタイトルの代替 |
| description | tableOfContents | リソースの目次を提供 |
|             | abstract        | リソースの要約を提供 |
| date        | created         | 作成日              |
|             | valid           | 有効期日もしくは期間 |
|             | available       | 利用可能日もしくは期間 |
|             | issued          | 正式発行日          |
|             | modified        | 更新日              |
|             | dateAccepted    | （論文やジャーナル記事などの）受理日 |
|             | dateCopyrighted | 著作権日 |
|             | dateSubmitted   | （論文やジャーナル記事などの）提出日 |
| format      | extent          | サイズもしくは時間 |
|             | medium          | リソースの搬送媒体 |
| relation    | isVersionOf     | リソースはこの要素が示すリソースのバージョン |
|             | hasVersion      | リソースはこの要素が示すリソースをバージョンとして持つ |
|             | isReplacedBy    | 要素が示すリソースで置き換えられる |
|             | replaces | 要素が示すリソースを置き換える |
|             | isRequiredBy    | 要素が示すリソースで必要とされる |
|             | requires        | 要素が示すリソースを必要とする |
|             | isPartOf        | リソースは要素が示すリソースの一部 |

- 拡張プロパティを使用したRDF/XMLの例

```xml
<rdf:Description rdf:about="urn:pin:BL608">
  <dc:creator>Tim Berners-Lee</dc:creator>
  <dcterms:created>2004-04-01</dcterms:created>
</rdf:Description>
```

## RDFデータの作成と検証

### ルール

- 実際のRDF/XMLデータは次のように記述する．
  - XMLデータなので，XML宣言が必要である．
    - `<?xml version="1.0" encoding="Shift_JIS" ?>`
  - rdf:RDF要素において，述語などで用いられている接頭辞(dc:やex:など)に対する名前空間URIを宣言する．
    - `<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:ex="http://example.org/" >`
  - 文書要素としてrdf:RDF要素を記述し，その内側に（これまでの例で示したような）rdf:Description要素などを記述していく．
  - W3C(World Wide Web Consortium) RDF/XML Validation Serviceで検証
    - http://www.w3.org/RDF/Validator/
    - `Display Result Options`の`Triples only`を`Triples and Graph`に変更
    - このグラフは配布資料の表示とは若干異なる部分がある
      - 接頭辞がURIに展開されて表示される

```xml
<?xml version="1.0" encoding="Shift_JIS" ?>
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:ex="http://example.org/"
  xmlns:dc="http://purl.org/dc/elements/1.1/" > >
    <rdf:Description rdf:about="urn:pin:BL608">
      <ex:hasHomePage>
        <rdf:Description rdf:about="http://www.w3.org/People/Berners-Lee/" />
    </ex:hasHomePage>
  </rdf:Description>
</rdf:RDF>
```