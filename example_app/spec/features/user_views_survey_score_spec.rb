require 'spec_helper'

feature 'user views score for answering survey' do
  scenario 'view score' do
    survey = make_scored_survey
    answer_survey survey
    page.should have_survey_score
  end

  def make_scored_survey
    maker = SurveyMaker.new
    maker.scored_multiple_choice_question(
      'Choose a vowel',
      'B' => 0,
      'A' => 10,
      'Y' => 5
    )
    maker.scale_question 'Grammer', 0..10
    maker.survey
  end

  def answer_survey(survey)
    sign_in
    taker = SurveyTaker.new(survey)
    taker.complete 'Y', 6
  end

  def have_survey_score
    have_content('Score: 11')
  end
end
