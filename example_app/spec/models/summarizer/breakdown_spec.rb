require 'spec_helper'

describe Summarizer::Breakdown, '#summarize' do
  it 'asks the question for a breakdown' do
    question = build_stubbed(:question)
    question.stubs(breakdown: 'breakdown')
    breakdown = Summarizer::Breakdown.new({})

    result = breakdown.summarize(question)

    result.title.should eq question.title
    result.value.should eq 'breakdown'
  end
end
