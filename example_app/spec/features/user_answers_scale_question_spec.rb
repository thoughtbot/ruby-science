require 'spec_helper'

feature 'user answers scale question' do
  scenario 'with valid answer' do
    sign_in
    view_survey_with_question(
      :scale,
      { title: 'How many fingers do you have?' },
      { minimum: 0, maximum: 10 }
    )
    choose '10'
    submit_answers
    answer_to_question('How many fingers do you have?').
      should have_content('10')
  end
end
