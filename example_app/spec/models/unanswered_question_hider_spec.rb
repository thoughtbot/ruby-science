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
