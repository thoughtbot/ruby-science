require 'spec_helper'

feature 'User changes question type' do
  scenario 'with valid scale question' do
    question = create(:open_question, title: 'How many hands do you have?')
    edit_question question

    steps = change_type 'Scale Question' do
      fill_in_steps
    end

    page.should have_content('How many hands do you have?')
    steps.each do |step|
      page.should have_step(step)
    end
  end

  scenario 'sees correct question form' do
    question = create(:scale_question)
    edit_question question

    click_link 'Open Question'

    page.should_not have_css('label', text: 'Minimum')
  end

  scenario 'with valid open question' do
    submittable = create(:scale_submittable)
    question = create(:scale_question, submittable: submittable)
    edit_question question

    change_type 'Open Question' do
    end

    page.should_not have_step(submittable.minimum)
  end

  scenario 'with invalid question' do
    question = create(:open_question)
    edit_question question

    change_type 'Scale Question' do
    end

    page.should have_form_error

    steps = fill_in_steps
    submit_type

    steps.each do |step|
      page.should have_step(step)
    end
  end

  def change_type(type)
    click_link type
    result = yield
    submit_type
    result
  end

  def submit_type
    click_on 'Change Type'
  end

  def fill_in_steps
    fill_in 'Minimum', with: 1
    fill_in 'Maximum', with: 2
    %w(1 2)
  end

  def have_step(step)
    have_css('input[type=radio] + label', text: step.to_s)
  end
end
