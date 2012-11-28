class SurveyTaker
  include FactoryGirl::Syntax::Methods

  def initialize(survey)
    @survey = survey
    @completion = create(:completion, survey: @survey)
  end

  def answer(question, answer_text)
    create(
      :answer,
      question: question,
      text: answer_text,
      completion: @completion
    )
  end
end
