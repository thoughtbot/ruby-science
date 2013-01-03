class SurveyTaker
  include Capybara::DSL
  include Features
  include Rails.application.routes.url_helpers

  def initialize(survey)
    @survey = survey
  end

  def start
    view_survey @survey
  end

  def answer(question_title, answer_text)
    question = Question.find_by_title!(question_title)
    case question
    when OpenQuestion
      fill_in question_title, with: answer_text
    when ScaleQuestion, MultipleChoiceQuestion
      within %{li:contains("#{question_title}")} do
        choose answer_text
      end
    else
      raise "Can't answer #{question.inspect}"
    end
  end

  def finish
    submit_answers
  end
end
