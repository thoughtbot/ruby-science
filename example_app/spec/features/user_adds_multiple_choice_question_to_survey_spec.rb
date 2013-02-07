require 'spec_helper'

feature 'user adds multiple choice question to survey' do
  scenario 'with valid data' do
    view_editable_survey
    click_on 'Add Multiple Choice Question'
    fill_in 'Title', with: 'What is your favorite color?'
    add_options_with_text 'Blue', 'Red'
    submit_question
    page.should have_content('What is your favorite color?')
    page.should have_content('Blue')
    page.should have_content('Red')
  end

  def add_options_with_text(*texts)
    texts.each_with_index do |text, index|
      fill_in(
        "question_submittable_attributes_options_attributes_#{index}_text",
        with: text
      )
    end
  end
end
