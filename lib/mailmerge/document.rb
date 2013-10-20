require 'zip'

module Mailmerge
  class Document
    
    def initialize(file, options={}, &block)
      @file = file
      @zipfile = Zip::File.open file

      entry = @zipfile.get_entry "word/document.xml"
      @xmldata = entry.get_input_stream.read
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