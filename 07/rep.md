# 第7回出席課題

## (1)本のタイトル(title要素)

```xq
for $i in doc("jbisc10.xml")//title
return $i
```

## (2)本のタイトルをHTML形式で

```xq
<html>
    <body>
        <ol>
        {
            for $i in doc("jbisc10.xml")//title
            return <li>{data($i)}</li>
        }
        </ol>
    </body>
</html>
```

## (3)内部結合した2ファイルの本のタイトルと値段

```xq
<books>
{
    for $i in doc("jbisc10.xml")//book,
        $j in doc("price.xml")//book
    where $i/bibRecord = $j/bibRecord
    return <book>{$i/title,$j/price }</book>
}
</books>
```