require 'rexml/document'

class Traverse
  def initialize(xml)
    @xml = xml
    @doc = REXML::Document.new(File.new(@xml))
    @order_and_node_and_type = ->(order, node, type) {
      '%s|%s|%s' % [order, node, type]
    }
    @check_elm_or_text = ->(node) {
      node.kind_of?(REXML::Text) ?
        "text" : node.kind_of?(REXML::Element) ?
          "element" : "unknown"
    }
    @node_path = ->(parent, current) {
      '%s|%s' % [parent, current]
    }
  end

  def traverse(node, order, parent)
    puts @node_path.call(parent, order) if parent != 0
    tmp = order
    order += 1
    if node.has_text? && ! node.has_elements?
        node.texts.each { |text|
            puts @node_path.call(order - 1, order)
            order += 1
        }
    end
    node.elements.each do |child|
      order = traverse(child, order, tmp)
    end
    return order
  end

  def execute
    traverse(@doc.root, 1, 0)
    return 0
  end

end

def main
  t = Traverse.new($*[0])
  t.execute
end

exit(main)
