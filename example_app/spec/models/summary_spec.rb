require 'spec_helper'

describe Summary, '#title' do
  it 'returns the title' do
    Summary.new('hello', 'my friend').title.should eq 'hello'
  end
end

describe Summary, '#value' do
  it 'returns the value' do
    Summary.new('hello', 'my friend').value.should eq 'my friend'
  end
end
