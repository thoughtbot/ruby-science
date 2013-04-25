require 'spec_helper'

feature 'user unsubscribes from email notifications' do
  scenario 'with valid data' do
    email = generate(:email)
    unsubscribe_from_notifications email
    invite_user_to_survey email
    verify_notification_not_sent_to email
  end

  def unsubscribe_from_notifications(email)
    using_session 'unsubscriber' do
      visit new_unsubscribe_path(email: email)
      click_on 'Unsubscribe'
    end
  end

  def invite_user_to_survey(email)
    using_session 'inviter' do
      sign_in
      send_survey_invitation email, 'hello'
    end
  end

  def verify_notification_not_sent_to(email)
    find_email(email).should be_nil
  end
end
