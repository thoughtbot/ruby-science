require 'spec_helper'

describe UnansweredQuestionHider, '#summarize' do
  it 'returns a hidden summary given a user without an answer' do
    summarizer = stub('summarizer')
    user = build_stubbed(:user)
    question = stub_answered_question(user, false)
    hider = UnansweredQuestionHider.new(summarizer, user)

    result = hider.summarize(question)

    result.should eq UnansweredQuestionHider::NO_ANSWER
  end

  it 'delegates to the summarizer given a user with an answer' do
    user = build_stubbed(:user)
    question = stub_answered_question(user, true)
    summarizer = stub_summarizer(question, 'value')
    hider = UnansweredQuestionHider.new(summarizer, user)

    result = hider.summarize(question)

    result.should eq 'value'
  end

  def stub_summarizer(question, value)
    stub('summarizer').tap do |summarizer|
      summarizer.stubs(:summarize).with(question).returns(value)
    end
  end

  def stub_answered_question(user, answered)
    build_stubbed(:question).tap do |question|
      question.stubs(:answered_by?).with(user).returns(answered)
    end
  end
end
