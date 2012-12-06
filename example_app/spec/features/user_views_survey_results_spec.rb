require 'spec_helper'

feature 'user views survey results' do
  scenario 'view survey results' do
    maker = SurveyMaker.new
    maker.open_question 'Name?'
    maker.multiple_choice_question 'Favorite color?', 'Red', 'Blue'
    maker.scale_question 'Airspeed velocity?', 0..10
    survey = maker.survey

    sign_in
    answer_survey survey, 'Brian', 'Red', '10'
    answer_survey survey, 'Billy', 'Red', '10'
    answer_survey survey, 'Benny', 'Blue', '4'

    open_answer = summary_for_question('Name?')
    open_answer.should have_content('Brian')
    open_answer.should have_content('Billy')
    open_answer.should have_content('Benny')

    multiple_choice_answer = summary_for_question('Favorite color?')
    multiple_choice_answer.should have_content('67% Red')
    multiple_choice_answer.should have_content('33% Blue')

    slider_answer = summary_for_question('Airspeed velocity?')
    slider_answer.should have_content('Average: 8')
  end

  def answer_survey(survey, name, color, airspeed_velocity)
    view_survey survey
    fill_in 'Name?', with: name
    choose color
    choose airspeed_velocity
    submit_answers
  end

  def summary_for_question(question)
    page.find('.summary li', text: question)
  end
end
