feature 'user adds open question to survey' do
  include SurveySupport

  scenario 'add an open question' do
    sign_in
    view_survey
    click_on 'Add Open Question'
    fill_in 'Title', with: 'What is your favorite color?'
    submit_question
    page.should have_content('What is your favorite color?')
  end
end
