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

    summary_for_question('Name?').should eq('Brian, Billy')
    summary_for_question('Favorite color?').should eq('50% Blue, 50% Red')
    summary_for_question('Airspeed velocity?').should eq('Average: 7.50')

    view_completions survey

    page.should have_content('Brian')
    page.should have_content('Billy')
    page.should have_content('Red')
    page.should have_content('Blue')
    page.should have_content('10')
    page.should have_content('5')
  end

  def view_completions(survey)
    click_on 'View all answers'
  end
end
