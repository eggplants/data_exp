# XMLのためのスキーマ言語

## DTD

- SGML -> 必須
- XML -> オプション

### 要素型宣言

`<!ELEMENT 要素名 内容モデル>`
`(子要素1, 子要素2, ...)`
テキストは`#PCDATA`
空要素は`EMPTY`
全ては`ANY`

### 属性リスト宣言

`<!ATTLIST 要素名 属性名 属性の型 デフォルト値>`
| 型名     | 意味                                       |
| :------- | :----------------------------------------- |
| CDATA    | 任意の文字列                               |
| ID       | 識別子．「名前」の形式でなければならない． |
| IDREFID  | 型の属性で指定された識別子の参照．         |
| NMTOKEN  | 「名前トークン」という文字列               |
| NMTOKENS | 「名前トークン」の列挙                     |
| ENTITY   | 実体参照値                                 |
| ENTITIES | 実体参照値の列挙                           |
必須`#REQIRED`
オプション`#IMPLIED`

## XML Schema

### 単純型

- 組み込みデータ型
名前空間の宣言は`xml ns:xsd=""`

```xml
<?xml version="1.0" encoding="Shift_JIS"?>
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <xsd:element name="artist" type="xsd:string" />
</xsd:schema>
```

- ユーザ派生データ型

`type=""`は定義可能

1. 制限

```xml
<xsd:simpleType name="ScoreType">
<xsd:restriction base="xsd:int">
<xsd:minInclusive value="0" />
<xsd:maxInclusive value="100" />
<!--
<xsd:minExclusive value="0" />
<xsd:maxExclusive value="100" />
-->
```

数値制約ファセット 意味
minInclusive最小値(指定された値を含む)
minExclusive最小値(指定された値を含まない)
maxInclusive最大値(指定された値を含む)
maxExclusive最大値(指定された値を含まない)
totalDigits桁数の上限
fractionDigits小数部の桁数の上限

```xml
<?xml version="1.0" encoding="Shift_JIS" ?>
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<xsd:element name="name" type="NameType" />
<xsd:simpleType name="NameType">
<xsd:restriction base="xsd:string">
<xsd:minLength value="2" />
<xsd:maxLength value="10" />
</xsd:restriction>
</xsd:simpleType>
</xsd:schema>
```

文字列制限ファセット
length  (長さ)
minLength (長さの下限)
maxLength (長さの上限)

1. 列挙

```xml
<?xml version="1.0" encoding="Shift_JIS" ?>
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <xsd:element name="day" type="DayType" />
  <xsd:simpleType name="DayType">
    <xsd:restriction base="xsd:string">
      <xsd:enumeration value="Sun" />
      <xsd:enumeration value="Mon" />
      <xsd:enumeration value="Tue" />
      <xsd:enumeration value="Wed" />
      <xsd:enumeration value="Thu" />
      <xsd:enumeration value="Fri" />
      <xsd:enumeration value="Sat" />
    </xsd:restriction>
  </xsd:simpleType>
</xsd:schema>
```

1. 正規表現

```xml
<?xml version="1.0" encoding="Shift_JIS" ?>
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <xsd:element name="isbn" type="IsbnType" />
  <xsd:simpleType name="IsbnType">
    <xsd:restriction base="xsd:string">
      <xsd:patternvalue="ISBN[0-9]{1}-[0-9]{3,5}-[0-9]{4}-[0-9A-Z]{1}" />
    </xsd:restriction>
  </xsd:simpleType>
</xsd:schema>
```

1. ユニオン

```xml
<?xml version="1.0" encoding="Shift_JIS" ?>
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <xsd:element name="report" type="ReportType" />
  <xsd:simpleType name="ReportType">
    <xsd:union memberTypes="ScoreType ExceptionType" />
  </xsd:simpleType>
  <xsd:simpleType name="ScoreType">
    <xsd:restriction base="xsd:int">
      <xsd:minInclusive value="0" />
      <xsd:maxInclusive value="100" />
    </xsd:restriction>
  </xsd:simpleType>
  <xsd:simpleType name="ExceptionType">
    <xsd:restriction base="xsd:string">
      <xsd:enumeration value="未提出" />
      <xsd:enumeration value="放棄" />
    </xsd:restriction>
  </xsd:simpleType>
</xsd:schema>
```

### 複合型(単純型内容)

### 複合型(複合型内容)

## RELAX NG
