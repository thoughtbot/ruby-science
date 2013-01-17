require 'spec_helper'

feature 'user views survey completions' do
  scenario 'view survey completions' do
    maker = SurveyMaker.new
    maker.open_question 'Name?'
    maker.multiple_choice_question 'Favorite color?', 'Red', 'Blue'
    maker.scale_question 'Airspeed velocity?', 0..10
    survey = maker.survey
    taker = SurveyTaker.new(survey)

    sign_in
    taker.complete 'Brian', 'Red', '10'
    taker.complete 'Billy', 'Blue', '5'

    view_completions survey

    page.should have_content('Brian')
    page.should have_content('Billy')
    page.should have_content('Red')
    page.should have_content('Blue')
    page.should have_content('10')
    page.should have_content('5')
  end

  def view_completions(survey)
    visit survey_completions_path(survey)
  end
end
