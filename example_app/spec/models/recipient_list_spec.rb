require 'spec_helper'

describe '#map' do
  it 'parses recipients separated by commas' do
    recipient_list('one@example.com, two@example.com').should 
      eq ['one@example.com', 'two@example.com']
  end

  it 'parses recipients separated by newlines' do
    recipient_list("one@example.com\ntwo@example.com").should 
      eq ['one@example.com', 'two@example.com']
  end

  it 'parses recipients separated by semi-colons' do
    recipient_list("one@example.com; two@example.com").should 
      eq ['one@example.com', 'two@example.com']
  end

  def recipient_list(string)
    RecipientList.new(string).map(&:to_s)
  end
end

describe RecipientList, '#to_s' do
  it 'returns the original string' do
    RecipientList.new('some string').to_s.should eq 'some string'
  end
end
