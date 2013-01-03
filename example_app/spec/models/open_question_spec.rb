describe OpenQuestion, '#score' do
  it 'returns zero' do
    question = build_stubbed(:open_question)

    result = question.score('anything')

    result.should eq 0
  end
end

describe OpenQuestion, '#summary' do
  it 'returns all answers' do
    survey = create(:survey)
    question = create(:open_question, survey: survey)
    taker = AnswerCreator.new(survey)

    taker.answer question, 'Hey'
    taker.answer question, 'Hi'
    taker.answer question, 'Hello'

    question.summary.should eq 'Hey, Hi, Hello'
  end
end
