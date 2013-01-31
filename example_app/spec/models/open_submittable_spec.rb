describe OpenSubmittable do
  it { should have_one(:question) }
end

describe OpenSubmittable, '#breakdown' do
  it 'returns all answers' do
    survey = create(:survey)
    question = create(:open_question, survey: survey)
    submittable = OpenSubmittable.new(question: question)
    taker = AnswerCreator.new(survey)

    taker.answer question, 'Hey'
    taker.answer question, 'Hi'
    taker.answer question, 'Hello'

    submittable.breakdown.should eq 'Hey, Hi, Hello'
  end
end

describe OpenSubmittable, '#score' do
  it 'returns zero' do
    question = build_stubbed(:open_question)
    submittable = OpenSubmittable.new(question: question)

    result = submittable.score('anything')

    result.should eq 0
  end
end
