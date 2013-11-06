require "zip"
require "nokogiri"

module Mailmerge
  class Document
    attr_reader :fields
    
    DOCUMENT_TYPE = "application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"

    def initialize(file, options={}, &block)
      begin
        @zipfile = Zip::File.open file
        @main_document = find_main_document
        @main_xml = load_document
      rescue Exception
        raise Mailmerge::DocumentError, "Invalid word document"
      end

      @fields = parse_fields
    end

    def write(filename)
      File.open(filename, "w") {|f| f.write(build_zip) }
    end

    def to_docx
      build_zip
    end
    
    private
      def find_main_document
        index = @zipfile.get_entry "[Content_Types].xml"
        data = index.get_input_stream.read
        docnode = Nokogiri::XML(data).xpath("//xmlns:Override[@ContentType='#{DOCUMENT_TYPE}']").first
        docnode.attributes['PartName'].value[1..-1]
      end

      def load_document
        data = @zipfile.get_entry(@main_document).get_input_stream.read
        Nokogiri::XML(data)
      end

      def parse_fields
        @main_xml.xpath('//w:fldSimple').map {|f| Mailmerge::Fields::SimpleField.new(f, @main_xml)}
      end

      def build_zip
        buffer = Zip::OutputStream.write_buffer do |out|
          @zipfile.entries.each do |e|
            if e.name == @docfile
              out.put_next_entry(@docfile)
              out.write @xmlfile.to_xml(:indent => 0).gsub("\n", "")
            else
              out.put_next_entry(e.name)
              out.write e.get_input_stream.read
            end
          end
        end
        buffer.string
      end
  end
end