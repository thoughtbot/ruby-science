require 'spec_helper'

describe Summarizer::MostRecent, '#summarize' do
  it 'returns the most recent answer text' do
    question = build_stubbed(:question)
    question.stubs(most_recent_answer_text: 'result')
    summarizer = Summarizer::MostRecent.new({})

    result = summarizer.summarize(question)

    result.title.should eq question.title
    result.value.should eq 'result'
  end
end
