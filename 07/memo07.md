# 第7回

## XQuery

- XMLデータの加工や検索を行うための高機能な検索言語
- XPathの機能も包含
- XPathは機能的に不十分であったため，より高機能な検索言語の必要性
- 2007年にXQuery 1.0がW3C勧告
- 2014年に拡張であるXQuery 3.0がW3C勧告

## FLWOR式

- `for`, `let`, `where`, `order by`, `return`の頭文字

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<catalog>
    <book>
        <title>三四郎</title>
        <author>
            <family>夏目</family>
            <given>漱石</given>
        </author>
    </book>
    <book>
        <title>柿の種</title>
        <author>
            <family>寺田</family>
            <given>寅彦</given>
        </author>
    </book>
    <book>
        <title>蜘蛛の糸</title>
        <author>
            <family>芥川</family>
            <given>龍之介</given>
        </author>
    </book>
</catalog>
```

- 上のXMLから名字(`family`)が`芥川`か`夏目`の`title`を抽出

```xquery
for $book in doc("book2.xml")//book
let $family := $book/author/family
where $family = "芥川" or $family = "夏目"
return $book/title
```

- `title`一覧

```xquery
for $book in doc("book2.xml")//book
return $book/title
```

- `ul`リスト
- タグの中にXQuery式を書く場合，その部分を中括弧(`{...}`)で囲む必要がある
- `data(xpath)`でテキストノードをタグ削除して出力

```html
<html>
    <body>
        <ul>
        {
        for $book in doc("book2.xml")//book
        return <li>{data($book/title)}</li>
        }
        </ul>
    </body>
</html>
```

- `count(xpath)`で要素数を出力
- `doc(filepath)`で文章全体を指定

```html
<html>
    <body>
        <p>本の冊数は{count(doc("book2.xml")//book)}です．</p>
    </body>
</html>
```

- 属性を`data()`なしで書き出すと要素の属性になる

```html
<html>
    <body>
        <ul>
        {
        for $book in doc("book3.xml")//book
        return <li>{$book/@id, data($book/title)}</li>
        }
        </ul>
    </body>
</html>
```

- `data()`で属性を囲むと要素と同じくテキストノードが取れる

```html
<html>
    <body>
        <ul>
        {
        for $book in doc("book3.xml")//book
        return <li>ID:{data($book/@id)} タイトル：{data($book/title)}</li>
        }
        </ul>
    </body>
</html>
```

## join

- 複数のxmlの共通データを結合して検索を行える
- `order.xml`の`bookid`要素と`book4.xml`の`id`要素を内部結合

```xml
<!-- book4.xml -->
<?xml version="1.0" encoding="UTF-8" ?>
<catalog>
    <book>
        <id>b001</id>
        <title>三四郎</title>
        <author>
            <family>夏目</family>
            <given>漱石</given>
        </author>
    </book>
    <book>
        <id>b002</id>
        <title>柿の種</title>
        <author>
            <family>寺田</family>
            <given>寅彦</given>
        </author>
    </book>
    <book>
        <id>b003</id>
        <title>蜘蛛の糸</title>
        <author>
            <family>芥川</family>
            <given>龍之介</given>
        </author>
    </book>
</catalog>
```

```xml
<!-- order.xml -->
<?xml version="1.0" encoding="utf-8"?>
<order>
  <item>
    <bookid>b001</bookid>
    <quantity>2</quantity>
  </item>
  <item>
    <bookid>b002</bookid>
    <quantity>3</quantity>
  </item>
  <item>
    <bookid>b003</bookid>
    <quantity>1</quantity>
  </item>
</order>
```

```xml
<!-- order2.xml -->
<?xml version="1.0" encoding="utf-8"?>
<order>
  <item>
    <bookid>b001</bookid>
    <quantity>2</quantity>
  </item>
  <item>
    <bookid>b002</bookid>
    <quantity>3</quantity>
  </item>
</order>
```

```xquery
for $item in doc("order.xml")//item,
    $book in doc("book4.xml")//book
where $item/bookid = $book/id
return <item id="{$book/id}">
        {$book/title}
        {$item/quantity}
</item>
```

- 対応データがない場合でも結合を行うとき外部結合
- `order2.xml`に対応データがなくても空要素で`quantity`を出力

```xquery
for $book in doc("book4.xml")//book
return <item id="{$book/id}">
    {$book/title}
    <quantity>
    {
        for $item in doc("order2.xml")//item
        where $item/bookid = $book/id
        return data($item/quantity)
    }
    </quantity>
</item>
```

## order by

- 並べ替えは`order by`で、指定した要素をキーとして並べ替える
- デフォルトでは`ascending`、降順なら`descending`を指定

```xquey
for $record in doc("record.xml")//record
order by $record/score
return $record
```

## グループ

- クラスごとに生徒の成績を表示
- クラスをuniqsortして回し、同じ`$class`を持つ生徒を`let`束縛し回す

```xquery
for $class in distinct-values(doc("record2.xml")//class)
let $records := doc("record2.xml")//record[class = $class]
order by $class
return
    <class no="{$class}">
    {
    for $record in $records
    return <record>{$record/id} {$record/score}</record>
    }
    </class>
```
