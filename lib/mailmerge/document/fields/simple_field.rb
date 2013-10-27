module Mailmerge
  module Fields
    class SimpleField
      attr_reader :name
      attr_reader :value
      
      FIELD_RE = 'MERGEFIELD "?([^ ]+?)"? (| \\\* MERGEFORMAT )'

      def initialize(field, document)
        @xmldata = field
        @document = document
        @value = ""
        #puts @xmldata.inspect
        parse_name
        replace_xml
      end

      def parse_name
        value = @xmldata.attributes['instr'].value
        @name = value.match(FIELD_RE)[1]
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
end