require 'spec_helper'

feature 'user views survey summary' do
  scenario 'view survey breakdown' do
    maker = SurveyMaker.new
    maker.open_question 'Name?'
    maker.multiple_choice_question 'Favorite color?', 'Red', 'Blue'
    maker.scale_question 'Airspeed velocity?', 0..10
    survey = maker.survey
    taker = SurveyTaker.new(survey)
    sign_in
    taker.complete 'Brian', 'Red', '10'
    as_another_user { taker.complete 'Billy', 'Red', '10' }
    as_another_user { taker.complete 'Benny', 'Blue', '4' }

    view_summary survey, 'Breakdown'

    summary_for_question('Name?').should eq('Brian, Billy, Benny')
    summary_for_question('Favorite color?').should eq('67% Red, 33% Blue')
    summary_for_question('Airspeed velocity?').should eq('Average: 8.00')
  end

  scenario 'view most recent answers' do
    maker = SurveyMaker.new
    maker.open_question 'Name?'
    survey = maker.survey
    taker = SurveyTaker.new(survey)
    sign_in
    taker.complete 'Brian'
    taker.complete 'Billy'

    view_summary survey, 'Most Recent'

    summary_for_question('Name?').should eq('Billy')
  end

  scenario 'only view questions which you have answered' do
    maker = SurveyMaker.new
    maker.open_question 'Name?'
    maker.open_question 'Favorite color?'
    survey = maker.survey
    taker = SurveyTaker.new(survey)
    sign_in
    taker.complete 'Brian', ''
    as_another_user { taker.complete 'Billy', 'Red' }

    view_summary survey, 'Most Recent'

    summary_for_question('Name?').should eq('Billy')
    summary_for_question('Favorite color?').
      should eq("You haven't answered this question")

    show_unanswered_questions

    summary_for_question('Favorite color?').
      should eq('Red')
  end

  scenario 'view your answers' do
    maker = SurveyMaker.new
    maker.open_question 'Name?'
    survey = maker.survey
    taker = SurveyTaker.new(survey)
    sign_in
    taker.complete 'Brian'
    as_another_user { taker.complete 'Billy' }

    view_summary survey, 'Your Answers'

    summary_for_question('Name?').should eq('Brian')
  end

  scenario 'view missing answers' do
    maker = SurveyMaker.new
    maker.open_question 'Name?'
    survey = maker.survey
    taker = SurveyTaker.new(survey)
    sign_in
    as_another_user { taker.complete 'Billy' }

    view_summary survey, 'Your Answers'
    show_unanswered_questions

    summary_for_question('Name?').should eq('No response')
  end

  def show_unanswered_questions
    click_on "Show questions I haven't answered"
  end

  def view_summary(survey, type)
    visit survey_path(survey)
    click_link type
  end
end
