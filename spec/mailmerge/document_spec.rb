require 'minitest/autorun'
require 'mailmerge'

describe Mailmerge::Document do
  let(:file) { 'spec/support/test.docx' }
  
  it "opens a document" do
    Mailmerge::Document.new(file).must_be_instance_of Mailmerge::Document
  end

  it "parses fields" do
    document = Mailmerge::Document.new(file)
    document.fields.size.must_equal 2
  end
end