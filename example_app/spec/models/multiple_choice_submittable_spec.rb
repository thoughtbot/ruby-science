describe MultipleChoiceSubmittable, '#score' do
  it 'returns the score for the option with the given text' do
    question = build_stubbed(:multiple_choice_question)
    submittable = MultipleChoiceSubmittable.new(question)
    question.options.stubs(score: 2)

    result = submittable.score('two')

    question.options.should have_received(:score).with('two')
    result.should eq 2
  end
end
