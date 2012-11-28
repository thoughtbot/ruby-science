feature 'user answers multiple choice question' do
  include SurveySupport

  scenario 'answer a multiple choice question' do
    sign_in
    view_survey_with_question :multiple_choice,
      title: 'What is your favorite color?',
      options_texts: %w(Red Blue)
    choose 'Red'
    submit_answers
    answer_to_question('What is your favorite color?').
      should have_content('Red')
  end
end
