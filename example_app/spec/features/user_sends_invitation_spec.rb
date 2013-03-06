require 'spec_helper'

feature 'User sends invitation' do
  before :each do
    sign_in
  end

  scenario 'with valid email address' do
    send_survey_invitation valid_email, valid_message

    page.should have_content('Invitation successfully sent')
  end

  scenario 'with valid email and invalid email' do
    send_survey_invitation "#{invalid_email}, #{valid_email}", valid_message

    page.should have_form_error
  end

  scenario 'with invalid message' do
    send_survey_invitation valid_email, invalid_message

    page.should have_form_error
  end

  scenario 'with invalid email address' do
    send_survey_invitation invalid_email, valid_message

    page.should have_form_error
  end

  scenario 'to existing user' do
    send_survey_invitation existing_email, valid_message

    as_user existing_user do
      visit root_path
      page.should have_invitation
    end
  end

  def send_survey_invitation(recipients, message)
    survey = create(:survey, author: current_user)
    visit survey_path(survey)
    click_link 'Invite'
    fill_in 'Message', with: message
    fill_in 'Recipients', with: recipients
    click_button 'Invite'
  end

  def valid_email
    'tester@example.com'
  end

  def invalid_email
    'invalid_email'
  end

  def existing_email
    existing_user.email
  end

  def existing_user
    @existing_user ||= create(:user)
  end

  def have_invitation
    have_css('.message', text: valid_message)
  end

  def valid_message
    'Fill out the survey now!'
  end

  def invalid_message
    ''
  end
end
