require 'spec_helper'

describe Summarizer::UserAnswer, '#summarize' do
  it 'returns the answer for the given user' do
    question = build_stubbed(:question)
    user = build_stubbed(:user)
    summarizer = Summarizer::UserAnswer.new(user: user)
    user.stubs(answer_text_for: 'result')

    result = summarizer.summarize(question)

    user.should have_received(:answer_text_for).with(question)
    result.should eq 'result'
  end
end
