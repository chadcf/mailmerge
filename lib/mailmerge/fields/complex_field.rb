module Mailmerge::Fields
  class ComplexField
    attr_reader :name
    attr_reader :value
    
    FIELD_RE = 'MERGEFIELD "?([^ ]+?)"? (| \\\* MERGEFORMAT )'

    def initialize(field, document)
      @node = field
      @instruction = find_instruction

      @document = document
      @value = ""
      @name = parse_name
      replace_xml
    end

    def find_instruction
      @node.parent.next.child
    end

    def parse_name
      @instruction.text.match(FIELD_RE)[1]
    end

    def replace_xml
      parent = Nokogiri::XML::Element.new 'w:r', @document
      @node = Nokogiri::XML::Element.new 'w:t', @document
      parent.add_child(@node)
      @node.content = ""
      @xmldata.replace(parent)
    end

    def value=(value)
      @value = value
      @node.content = value
    end
  end
end