require 'spec_helper'

feature 'User edits open question' do
  scenario 'with valid data' do
    survey = create(:survey, title: 'Survey Name')
    question = create(:question, survey: survey)
    sign_in
    update_question(question)

    expect(page).to have_content('Updated title')
  end

  def update_question(question)
    click_link 'Survey Name'
    within(:xpath, "//li[@data-id=#{question.id}]") do
      click_link 'Edit'
    end
    fill_in 'Title', with: 'Updated title'
    click_on 'Update Question'
  end
end
