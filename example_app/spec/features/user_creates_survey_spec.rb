require 'spec_helper'

feature 'user creates survey' do
  scenario 'with valid data' do
    sign_in
    start_new_survey
    submit_survey_with_title 'How are you?'
    page.should have_content('How are you?')
  end

  scenario 'with invalid data' do
    sign_in
    start_new_survey
    submit_survey_without_title
    page.should have_form_error
    submit_survey_with_title 'How are you?'
    page.should have_content('How are you?')
  end

  def submit_survey_without_title
    submit_survey_with_title ''
  end
end
