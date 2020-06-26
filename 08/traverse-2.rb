# frozen_string_literal: true

require 'rexml/document'

def traverse(node, order)
  cd = ->(node){
   '%sは子にテキストノードを持つ%s' % [node.name, ?\n]
  }
  print(
    '%s, %s%s' % [order, node.name, ?\n],
    node.has_text? && ! node.has_elements? ? node_text_info.call(node) : ""
  )
  order += 1
  node.elements.each do |child|
    order = traverse(child, order)
  end
  return order
end

def main
  doc = REXML::Document.new(
    File.new('sample.xml')
  )

  # search DOM
  traverse(doc.root, 1)
  return 0
end
exit(main)
