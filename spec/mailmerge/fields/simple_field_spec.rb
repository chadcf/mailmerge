require 'minitest/autorun'
require 'mailmerge'

describe Mailmerge::Fields::SimpleField do
  let(:file) { 'spec/support/simple.docx' }
  
  before do
    @document = Mailmerge::Document.new(file)
  end

  it "lists field names" do
    @document.fields.first.name.must_equal "status"
  end

  it "sets field values" do
    @document.fields.first.value = "New Value"
    @document.fields.first.value.must_equal "New Value"
  end

end