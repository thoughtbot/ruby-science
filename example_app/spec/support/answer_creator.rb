class AnswerCreator
  include FactoryGirl::Syntax::Methods

  def initialize(survey, options = {})
    @survey = survey
    @completion = create(:completion, options.merge(survey: @survey))
  end

  def answer(question, answer_text = 'hello')
    create(
      :answer,
      question: question,
      text: answer_text,
      completion: @completion
    )
  end
end
