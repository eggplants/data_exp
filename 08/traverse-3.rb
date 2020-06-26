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