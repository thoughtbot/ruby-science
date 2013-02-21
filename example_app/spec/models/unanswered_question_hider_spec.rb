require 'spec_helper'

describe UnansweredQuestionHider, '#summary_or_hidden_answer' do
  it 'returns a hidden summary given a user without an answer' do
    summarizer = stub('summarizer')
    user = build_stubbed(:user)
    question = stub_answered_question(user, false)
    hider = UnansweredQuestionHider.new(summarizer, user)

    result = hider.summary_or_hidden_answer(question)

    result.title.should eq question.title
    result.value.should eq UnansweredQuestionHider::NO_ANSWER
  end

  it 'delegates to the summarizer given a user with an answer' do
    summary = stub('summary')
    user = build_stubbed(:user)
    question = stub_answered_question(user, true)
    summarizer = stub_summarizer(question, summary)
    hider = UnansweredQuestionHider.new(summarizer, user)

    result = hider.summary_or_hidden_answer(question)

    result.should eq summary
  end

  it 'delegates to the summarizer without a user' do
    summary = stub('summary')
    question = build_stubbed(:question)
    summarizer = stub_summarizer(question, summary)
    hider = UnansweredQuestionHider.new(summarizer, nil)

    result = hider.summary_or_hidden_answer(question)

    result.should eq summary
  end

  def stub_summarizer(question, summary)
    stub('summarizer').tap do |summarizer|
      question.stubs(:summary_using).with(summarizer).returns(summary)
    end
  end

  def stub_answered_question(user, answered)
    build_stubbed(:question).tap do |question|
      question.stubs(:answered_by?).with(user).returns(answered)
    end
  end
end
