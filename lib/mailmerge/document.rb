require "zip"
require "nokogiri"
require "mailmerge/document/fields"

module Mailmerge
  class Document
    attr_reader :fields
    
    DOCUMENT_TYPE = "application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"

    def initialize(file, options={}, &block)
      @file = file
      @zipfile = Zip::File.open @file

      load_document
      parse_fields
    end

    private
      def load_document
        index = @zipfile.get_entry "[Content_Types].xml"
        data = index.get_input_stream.read
        docnode = Nokogiri::XML(data).xpath("//xmlns:Override[@ContentType='#{DOCUMENT_TYPE}']").first
        entry = docnode.attributes['PartName'].value
        @xmldata = @zipfile.get_entry(entry[1..-1]).get_input_stream.read
      end

      def parse_fields
        @fields = Array.new
        Nokogiri::XML(@xmldata).xpath('//w:fldSimple').each do |field|
          @fields << Mailmerge::Fields::SimpleField.new(field)
        end
      end

    def write
      # buffer = Zip::OutputStream.write_buffer do |out|
      #   @zip_file.entries.each do |e|
      #     unless [DOCUMENT_FILE_PATH, RELS_FILE_PATH].include?(e.name)
      #       out.put_next_entry(e.name)
      #       out.write e.get_input_stream.read
      #      end
      #   end

      #   out.put_next_entry(DOCUMENT_FILE_PATH)
      #   out.write xml_doc.to_xml(:indent => 0).gsub("\n","")

      #   out.put_next_entry(RELS_FILE_PATH)
      #   out.write rels.to_xml(:indent => 0).gsub("\n","")
      # end

      # File.open(new_path, "w") {|f| f.write(buffer.string) }    
    end
  end
end
