describe MultipleChoiceSubmittable do
  it { should have_many(:options) }
  it { should have_one(:question) }
end

describe MultipleChoiceSubmittable, '#breakdown' do
  it 'returns a percentage breakdown' do
    survey = create(:survey)
    submittable = create(
      :multiple_choice_submittable,
      options_texts: %w(Blue Red)
    )
    question = create(
      :multiple_choice_question,
      submittable: submittable,
      survey: survey
    )
    submittable = MultipleChoiceSubmittable.new(question: question)
    taker = AnswerCreator.new(survey)
    taker.answer question, 'Red'
    taker.answer question, 'Blue'
    taker.answer question, 'Red'

    submittable.breakdown.should eq '67% Red, 33% Blue'
  end
end

describe MultipleChoiceSubmittable, '#options_for_form' do
  it 'adds empty options when none are present' do
    submittable = MultipleChoiceSubmittable.new(options: [])
    submittable.options_for_form.count.should == 3
  end

  it 'leaves existing options alone' do
    options = [Option.new(text: 'hey'), Option.new(text: 'hello')]
    submittable = MultipleChoiceSubmittable.new(options: options)
    submittable.options_for_form.map(&:text).should match_array(['hey', 'hello'])
  end
end

describe MultipleChoiceSubmittable, '#score' do
  it 'returns the score for the option with the given text' do
    question = build_stubbed(:multiple_choice_question)
    submittable = MultipleChoiceSubmittable.new(question: question)
    submittable.options.target.stubs(score: 2)

    result = submittable.score('two')

    submittable.options.target.should have_received(:score).with('two')
    result.should eq 2
  end
end
