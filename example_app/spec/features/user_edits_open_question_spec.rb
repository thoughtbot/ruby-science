require 'spec_helper'

feature 'User edits open question' do
  scenario 'with valid data' do
    question = create(:question)
    sign_in
    update_question(question, 'Updated title')

    expect(page).to have_content('Updated title')
  end

  def update_question(question, title)
    click_link question.survey_title
    page.find('li', text: question.title).click_link('Edit')
    fill_in 'Title', with: title
    click_on 'Update Question'
  end
end
