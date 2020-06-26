# データ表現と処理 第8回レポート

- 201811528 春名航亨 (知識情報・図書館学類 3年次)

## 演習1: サンプルコードの動作

- 以下に改変したサンプルコード`traverse-1.rb`を示す.

```ruby
require 'rexml/document'

def traverse(node, order)
  puts "#{order}, #{node.name}"
  order += 1
  node.elements.each { |child|
    order = traverse(child, order)
  }
  return order
end

def main
  doc = REXML::Document.new(
    File.new('sample.xml')
  )
  traverse(doc.root, 1)
  return 0
end
exit(main)
```

`$ ruby traverse-1.rb`と実行すると以下の実行結果を得た.

```text
1, books
2, book
3, title
4, author
5, book
6, title
7, author
```

## 演習2: テキストノードのみ子に持つ要素を判定

以下に作成した`traverse-2.rb`を示す.

```ruby
require 'rexml/document'

def traverse(node, order)
  node_text_info = ->(node){
   '%sは子にテキストノードを持つ%s' % [node.name, ?\n]
  }
  print(
    '%s, %s%s' % [order, node.name, ?\n],
    node.has_text? && ! node.has_elements? ? node_text_info.call(node) : ""
  )
  order += 1
  node.elements.each { |child|
    order = traverse(child, order)
  }
  return order
end

def main
  doc = REXML::Document.new(
    File.new('sample.xml')
  )

  traverse(doc.root, 1)
  return 0
end
exit(main)
```

`$ ruby traverse-2.rb`と実行すると以下の実行結果を得た.

```text
1, books
2, book
3, title
titleは子にテキストノードを持つ
4, author
authorは子にテキストノードを持つ
5, book
6, title
titleは子にテキストノードを持つ
7, author
authorは子にテキストノードを持つ
```

## 演習3: 演習2のプログラムでテキストノードも出力

以下に作成した`traverse-3.rb`を示す.

```ruby
require 'rexml/document'

class Traverse
  def initialize(xml)
    @xml = xml
    @order_and_node = ->(node, order){
      '%s, %s' % [order, node]
    }
  end
  
  def traverse(node, order)
    puts @order_and_node.call(node.name, order)
    order += 1
    if node.has_text? && ! node.has_elements? 
      node.texts.each { |text|
        puts @order_and_node.call(text, order)
        order += 1
      }
    end
    node.elements.each do |child|
      order = traverse(child, order)
    end
    return order
  end
  
  def execute
    doc = REXML::Document.new(
      File.new(@xml)
    )
        # search DOM
    traverse(doc.root, 1)
    return 0
  end

end

def main
  t = Traverse.new('sample.xml')
  t.execute
end

exit(main)
```

`$ ruby traverse-3.rb`と実行すると以下の実行結果を得た.

```text
1, books
2, book
3, title
4, 草枕
5, author
6, 夏目漱石
7, book
8, title
9, こゝろ
10, author
11, 夏目漱石
```

## 演習4: 演習3のプログラムでノードの種類も出力

以下に作成した`traverse-4.rb`を示す.

```ruby
require 'rexml/document'

class Traverse
  def initialize(xml)
    @xml = xml
    @order_and_node_and_type = ->(node, order, type) {
      '%s, %s, %s' % [order, node, type]
    }
    @check_elm_or_text = ->(node) {
      node.kind_of?(REXML::Text) ?
        "text" : node.kind_of?(REXML::Element) ?
          "element" : "unknown"
    }
  end
  
  def traverse(node, order)
    puts @order_and_node_and_type.call(
      node.name, order, @check_elm_or_text.call(node)
    )
    order += 1
    if node.has_text? && ! node.has_elements? 
      node.texts.each { |text|
        puts @order_and_node_and_type.call(
          text,
          order,
          @check_elm_or_text.call(text)
        )
        order += 1
      }
    end
    node.elements.each do |child|
      order = traverse(child, order)
    end
    return order
  end
  
  def execute
    doc = REXML::Document.new(
      File.new(@xml)
    )
        # search DOM
    traverse(doc.root, 1)
    return 0
  end

end

def main
  t = Traverse.new('sample.xml')
  t.execute
end

exit(main)
```

`$ ruby traverse-4.rb`と実行すると以下の実行結果を得た.

```text
1, books, element
2, book, element
3, title, element
4, 草枕, text
5, author, element
6, 夏目漱石, text
7, book, element
8, title, element
9, こゝろ, text
10, author, element
11, 夏目漱石, text
```