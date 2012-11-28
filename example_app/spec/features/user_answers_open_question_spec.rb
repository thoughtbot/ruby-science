feature 'user answers an open question' do
  include SurveySupport

  scenario 'answer an open question' do
    sign_in
    view_survey_with_question :open, title: 'What is your favorite color?'
    fill_in 'What is your favorite color?', with: 'Blue'
    submit_answers
    answer_to_question('What is your favorite color?').
      should have_content('Blue')
  end
end
