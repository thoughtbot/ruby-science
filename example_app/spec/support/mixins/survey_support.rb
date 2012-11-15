module SurveySupport
  def view_survey(survey = create(:survey))
    visit survey_path(survey)
  end

  def view_survey_with_question(type, attributes = {})
    survey = create(:survey)
    question = create(:"#{type}_question", attributes.merge(survey: survey))
    view_survey survey
  end

  def submit_question
    click_on 'Create Question'
  end

  def submit_answers
    click_on 'Submit Answers'
  end

  def answer_to_question(question)
    find('.question', text: question)
  end
end
