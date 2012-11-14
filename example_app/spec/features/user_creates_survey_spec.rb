feature 'user creates survey' do
  scenario 'create a valid survey' do
    sign_in
    start_new_survey
    submit_survey_with_title 'How are you?'
    page.should have_content('How are you?')
  end

  scenario 'attempt to create an invalid survey' do
    sign_in
    start_new_survey
    submit_survey_without_title
    page.should have_form_error
    submit_survey_with_title 'How are you?'
    page.should have_content('How are you?')
  end

  def start_new_survey
    click_on 'New Survey'
  end

  def submit_survey_without_title
    submit_survey_with_title ''
  end

  def submit_survey_with_title(title)
    fill_in 'Title', with: title
    click_on 'Create Survey'
  end
end
