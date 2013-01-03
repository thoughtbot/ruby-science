describe MultipleChoiceQuestion do
  it { should have_many(:options) }
end

describe MultipleChoiceQuestion, '#options_for_form' do
  it 'adds empty options when none are present' do
    question = build_stubbed(:multiple_choice_question, options: [])
    question.options_for_form.count.should == 3
  end

  it 'leaves existing options alone' do
    options = [Option.new(text: 'hey'), Option.new(text: 'hello')]
    question = build_stubbed(:multiple_choice_question, options: options)
    question.options_for_form.map(&:text).should match_array(['hey', 'hello'])
  end
end

describe MultipleChoiceQuestion, '#summary' do
  it 'returns a percentage breakdown' do
    survey = create(:survey)
    question = create(
      :multiple_choice_question,
      options_texts: %w(Blue Red),
      survey: survey
    )
    taker = AnswerCreator.new(survey)
    taker.answer question, 'Red'
    taker.answer question, 'Blue'
    taker.answer question, 'Red'

    question.summary.should eq '67% Red, 33% Blue'
  end
end
