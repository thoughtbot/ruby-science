require 'spec_helper'

describe Breakdown, '#summarize' do
  it 'asks the question for a breakdown' do
    question = build_stubbed(:question)
    question.stubs(breakdown: 'breakdown')
    breakdown = Breakdown.new({})

    result = breakdown.summarize(question)

    result.should == 'breakdown'
  end
end
