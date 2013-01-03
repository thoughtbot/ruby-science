require 'spec_helper'

feature 'user views score for answering survey' do
  scenario 'view score' do
    maker = SurveyMaker.new
    maker.scored_multiple_choice_question(
      'Choose a vowel',
      'B' => 0,
      'A' => 10,
      'Y' => 5
    )
    maker.scale_question 'Grammer', 0..10

    sign_in
    taker = SurveyTaker.new(maker.survey)
    taker.start
    taker.answer 'Choose a vowel', 'Y'
    taker.answer 'Grammer', 6
    taker.finish

    page.should have_content('Score: 11')
  end
end
