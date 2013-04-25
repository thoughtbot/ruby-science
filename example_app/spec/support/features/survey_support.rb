module Features
  def view_survey(survey = create(:survey))
    visit survey_path(survey)
  end

  def view_editable_survey
    sign_in
    survey = create(:survey, author: current_user)
    view_survey survey
  end

  def view_survey_with_question(type, question_attrs = {}, submittable_attrs = {})
    survey = create(:survey)
    submittable = create(:"#{type}_submittable", submittable_attrs)
    question = create(
      :"#{type}_question",
      question_attrs.merge(survey: survey, submittable: submittable)
    )
    view_survey survey
  end

  def send_survey_invitation(recipients, message)
    survey = create(:survey, author: current_user)
    visit survey_path(survey)
    click_link 'Invite'
    fill_in 'Message', with: message
    fill_in 'Recipients', with: recipients
    click_button 'Invite'
  end

  def submit_question
    click_on 'Create Question'
  end

  def submit_answers
    click_on 'Submit Answers'
  end

  def edit_question(question)
    sign_in
    click_link question.survey_title
    page.find('li', text: question.title).click_link('Edit')
  end

  def answer_to_question(question)
    find('.completion .question', text: question)
  end

  def summary_for_question(question)
    page.find('.summary li', text: question).find('.summary').text
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
