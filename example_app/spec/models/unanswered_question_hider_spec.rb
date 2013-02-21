require 'spec_helper'

describe UnansweredQuestionHider, '#hide_answer_to_question' do
  it 'returns a hidden summary' do
    question = build_stubbed(:question)
    hider = UnansweredQuestionHider.new

    result = hider.hide_answer_to_question(question)

    result.title.should eq question.title
    result.value.should eq UnansweredQuestionHider::NO_ANSWER
  end
end

describe UnansweredQuestionHider, '#hide_unanswered_question?' do
  it 'returns true given a user without an answer' do
    user = build_stubbed(:user)
    question = stub_answered_question(user, false)
    hider = UnansweredQuestionHider.new

    hider.hide_unanswered_question?(question, user).should be_true
  end

  it 'returns false given a user with an answer' do
    user = build_stubbed(:user)
    question = stub_answered_question(user, true)
    hider = UnansweredQuestionHider.new

    hider.hide_unanswered_question?(question, user).should be_false
  end

  it 'returns false without a user' do
    question = build_stubbed(:question)
    hider = UnansweredQuestionHider.new

    hider.hide_unanswered_question?(question, nil).should be_false
  end

  def stub_answered_question(user, answered)
    build_stubbed(:question).tap do |question|
      question.stubs(:answered_by?).with(user).returns(answered)
    end
  end
end
