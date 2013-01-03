require 'spec_helper'

describe Option do
  it { should validate_presence_of(:text) }

  it { should belong_to(:question) }
end

describe Option, '.score' do
  it 'returns the score for the option with the given text' do
    question = create(:question)
    create :option, text: 'one', score: 1, question: question
    create :option, text: 'two', score: 2, question: question

    result = Option.score('two')

    result.should eq 2
  end
end
