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
