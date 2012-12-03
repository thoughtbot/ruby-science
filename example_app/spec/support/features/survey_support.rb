module Features
  def view_survey(survey = create(:survey))
    visit survey_path(survey)
  end

  def view_editable_survey
    sign_in
    survey = create(:survey, author: current_user)
    view_survey survey
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

  def start_new_survey
    click_on 'New Survey'
  end

  def submit_survey_with_title(title)
    fill_in 'Title', with: title
    click_on 'Create Survey'
  end

  def create_survey_with_title(title)
    start_new_survey
    submit_survey_with_title title
  end
end
