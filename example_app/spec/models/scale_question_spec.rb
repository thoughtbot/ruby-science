describe ScaleQuestion do
  subject { build_stubbed(:scale_question) }

  it { should validate_presence_of(:maximum) }
  it { should validate_presence_of(:minimum) }
end

describe ScaleQuestion, '#score' do
  it 'returns the integer value of the text' do
    question = build_stubbed(:scale_question)

    result = question.score('5')

    result.should eq 5
  end
end

describe ScaleQuestion, '#steps' do
  it 'returns all numbers starting at the minimum and ending at the maximum' do
    question = build_stubbed(:scale_question, minimum: 2, maximum: 5)
    question.steps.should eq [2, 3, 4, 5]
  end
end

describe ScaleQuestion, '#summary' do
  it 'returns the average' do
    survey = create(:survey)
    question = create(:scale_question, minimum: 0, maximum: 10, survey: survey)
    taker = AnswerCreator.new(survey)
    taker.answer question, 6
    taker.answer question, 6
    taker.answer question, 8

    question.summary.should eq 'Average: 6.67'
  end
end
