class SurveyTaker
  include Capybara::DSL
  include Features
  include Rails.application.routes.url_helpers

  def initialize(survey)
    @survey = survey
  end

  def complete(*answer_texts)
    start

    @survey.questions.zip(answer_texts).each do |question, answer_text|
      answer question.title, answer_text
    end

    finish
  end

  def start
    view_survey @survey
  end

  def answer(question_title, answer_text)
    question = Question.find_by_title!(question_title)
    case question.submittable
    when OpenSubmittable
      fill_in question_title, with: answer_text
    when ScaleSubmittable, MultipleChoiceSubmittable
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
