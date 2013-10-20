require 'minitest/autorun'
require 'mailmerge'

describe Mailmerge::Document do
  @testfile = 'spec/support/test.docx'
  
  it "opens a document" do
    Mailmerge::Document.new(@testfile).must_be_instance_of Mailmerge::Document
  end

  it "parses fields" do
    document = Mailmerge::Document.new(@testfile)
    document.fields.size.must_equal 2
  end

end