describe NullAnswer, '#text' do
  it 'has content' do
    NullAnswer.new.text.should be_present
  end
end
