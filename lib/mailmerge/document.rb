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

    def write(filename)
      buffer = Zip::OutputStream.write_buffer do |out|
        @zipfile.entries.each do |e|
          puts e.name.inspect
          if e.name == @docfile
            puts 'swapping!'
            out.put_next_entry(@docfile)
            puts @xmlfile.to_xml
            out.write @xmlfile.to_xml(:indent => 0).gsub("\n", "")
          else
            out.put_next_entry(e.name)
            out.write e.get_input_stream.read
           end
        end
      end

      File.open(filename, "w") {|f| f.write(buffer.string) }
    end

    private
      def load_document
        index = @zipfile.get_entry "[Content_Types].xml"
        data = index.get_input_stream.read
        docnode = Nokogiri::XML(data).xpath("//xmlns:Override[@ContentType='#{DOCUMENT_TYPE}']").first
        @docfile = docnode.attributes['PartName'].value[1..-1]
        @xmldata = @zipfile.get_entry(@docfile).get_input_stream.read
        @xmlfile = Nokogiri::XML(@xmldata)
      end

      def parse_fields
        @fields = Array.new
        @xmlfile.xpath('//w:fldSimple').each do |field|
          @fields << Mailmerge::Fields::SimpleField.new(field, @xmlfile)
        end
      end


  end
end

# require 'rubygems'
# require 'zip/zip' # rubyzip gem
# require 'nokogiri'

# class WordXmlFile
#   def self.open(path, &block)
#     self.new(path, &block)
#   end

#   def initialize(path, &block)
#     @replace = {}
#     if block_given?
#       @zip = Zip::ZipFile.open(path)
#       yield(self)
#       @zip.close
#     else
#       @zip = Zip::ZipFile.open(path)
#     end
#   end

#   def merge(rec)
#     xml = @zip.read("word/document.xml")
#     doc = Nokogiri::XML(xml) {|x| x.noent}
#     (doc/"//w:fldSimple").each do |field|
#       if field.attributes['instr'].value =~ /MERGEFIELD (\S+)/
#         text_node = (field/".//w:t").first
#         if text_node
#           text_node.inner_html = rec[$1].to_s
#         else
#           puts "No text node for #{$1}"
#         end
#       end
#     end
#     @replace["word/document.xml"] = doc.serialize :save_with => 0
#   end

#   def save(path)
#     Zip::ZipFile.open(path, Zip::ZipFile::CREATE) do |out|
#       @zip.each do |entry|
#         out.get_output_stream(entry.name) do |o|
#           if @replace[entry.name]
#             o.write(@replace[entry.name])
#           else
#             o.write(@zip.read(entry.name))
#           end
#         end
#       end
#     end
#     @zip.close
#   end
# end
