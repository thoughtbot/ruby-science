require 'spec_helper'

describe User, '#answer_text_for' do
  it 'returns the answer text for the question by this user' do
    survey = create(:survey)
    question = create(:question, survey: survey)
    other_question = create(:question, survey: survey)
    user = create(:user)
    other_user = create(:user)
    AnswerCreator.new(survey, user: user).answer(question, 'expected')
    AnswerCreator.new(survey, user: user).answer(other_question, 'other question')
    AnswerCreator.new(survey, user: other_user).answer(question, 'other user')

    result = user.answer_text_for(question)

    result.should eq 'expected'
  end

  it 'returns text when no answer exists' do
    user = create(:user)
    question = create(:question)

    result = user.answer_text_for(question)

    result.should be_present
  end
end

describe User, '#full_name' do
  it 'returns the users full name' do
    user = User.new(first_name: 'First', last_name: 'Last')

    expect(user.full_name).to eq 'First Last'
  end
end
