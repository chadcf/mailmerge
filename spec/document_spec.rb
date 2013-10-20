require 'minitest/autorun'
require 'mailmerge'

describe Mailmerge::Document do
  it "opens a document" do
    Mailmerge::Document.new('spec/support/test.docx').must_be_instance_of Mailmerge::Document
  end
end