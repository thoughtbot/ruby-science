require 'spec_helper'

feature 'user attempts to add invalid question to survey' do
  scenario 'attempt to add an invalid question' do
    view_editable_survey
    click_on 'Add Open Question'
    submit_question
    page.should have_form_error
  end
end

