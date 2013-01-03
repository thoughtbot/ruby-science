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
