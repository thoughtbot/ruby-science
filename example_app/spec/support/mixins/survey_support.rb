module SurveySupport
  def view_survey
    survey = create(:survey)
    visit survey_path(survey)
  end

  def submit_question
    click_on 'Create Question'
  end
end
