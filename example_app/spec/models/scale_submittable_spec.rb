describe ScaleSubmittable do
  it { should have_one(:question) }
end

describe ScaleSubmittable, '#breakdown' do
  it 'returns the average' do
    survey = create(:survey)
    question = create(:scale_question, minimum: 0, maximum: 10, survey: survey)
    submittable = ScaleSubmittable.new(question: question)
    taker = AnswerCreator.new(survey)
    taker.answer question, 6
    taker.answer question, 6
    taker.answer question, 8

    submittable.breakdown.should eq 'Average: 6.67'
  end
end

describe ScaleSubmittable, '#score' do
  it 'returns the integer value of the text' do
    question = build_stubbed(:scale_question)
    submittable = ScaleSubmittable.new(question: question)

    result = submittable.score('5')

    result.should eq 5
  end
end

describe ScaleSubmittable, '#steps' do
  it 'returns all numbers starting at the minimum and ending at the maximum' do
    question = build_stubbed(:scale_question, minimum: 2, maximum: 5)
    submittable = ScaleSubmittable.new(question: question)
    submittable.steps.should eq [2, 3, 4, 5]
  end
end
