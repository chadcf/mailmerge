module Mailmerge
  module Fields
    class SimpleField
      attr_reader :name
      attr_accessor :value
      
      FIELD_RE = 'MERGEFIELD "?([^ ]+?)"? (| \\\* MERGEFORMAT )'

      def initialize(field)
        @xmldata = field
        parse_name
      end

      def parse_name
        value = @xmldata.attributes['instr'].value
        @name = value.match(FIELD_RE)[1]
      end
    end
  end
end