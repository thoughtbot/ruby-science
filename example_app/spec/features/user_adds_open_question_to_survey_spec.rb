require 'spec_helper'

feature 'user adds open question to survey' do
  scenario 'with valid data' do
    view_editable_survey
    click_on 'Add Open Question'
    fill_in 'Title', with: 'What is your favorite color?'
    submit_question
    page.should have_content('What is your favorite color?')
  end

  scenario 'with invalid data' do
    view_editable_survey
    click_on 'Add Open Question'
    submit_question
    page.should have_form_error
  end
end
