require 'spec_helper'

feature 'user adds scale question to survey' do
  scenario 'with valid data' do
    view_editable_survey
    click_on 'Add Scale Question'
    fill_in 'Title', with: 'How many fingers do you have?'
    fill_in 'Minimum', with: '0'
    fill_in 'Maximum', with: '10'
    submit_question
    page.should have_content('How many fingers do you have?')

    (0..10).each do |step|
      page.should have_content(step)
    end
  end
end
