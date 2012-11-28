describe MultipleChoiceQuestion do
  it { should have_many(:options) }
end

describe MultipleChoiceQuestion, '#summary' do
  it 'returns a percentage breakdown' do
    survey = create(:survey)
    question = create(
      :multiple_choice_question,
      options_texts: %w(Blue Red),
      survey: survey
    )
    taker = SurveyTaker.new(survey)
    taker.answer question, 'Red'
    taker.answer question, 'Blue'
    taker.answer question, 'Red'

    question.summary.should eq '67% Red, 33% Blue'
  end
end
