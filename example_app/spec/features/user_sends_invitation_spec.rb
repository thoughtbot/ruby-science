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

  def valid_email
    'tester@example.com'
  end

  def invalid_email
    'invalid_email'
  end

  def valid_message
    'Fill out the survey now!'
  end

  def invalid_message
    ''
  end
end
