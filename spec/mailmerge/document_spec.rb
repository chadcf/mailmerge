require 'minitest/autorun'
require 'mailmerge'

describe Mailmerge::Document do
  let(:simplefile) { 'spec/support/simple.docx' }
  let(:invalidfile) { 'spec/support/test.pdf' }

  it "opens a document" do
    Mailmerge::Document.new(simplefile).must_be_instance_of Mailmerge::Document
  end

  it "parses fields" do
    document = Mailmerge::Document.new(simplefile)
    document.fields.size.must_equal 3
  end

  it "writes the file" do
    document = Mailmerge::Document.new(simplefile)
    document.fields.first.value = 'Person'
    document.write("out.docx")
    File.exists?("out.docx").must_equal true
    File.delete("out.docx")
  end

  it "returns the file as a string" do
    document = Mailmerge::Document.new(simplefile)
    document.to_docx.must_be_instance_of String
  end

  it "throws error for non-existant file" do
    lambda { Mailmerge::Document.new("nofile.docx") }.must_raise Mailmerge::DocumentError
  end

  it "throws error for non word file" do
    lambda { Mailmerge::Document.new(invalidfile) }.must_raise Mailmerge::DocumentError
  end
end