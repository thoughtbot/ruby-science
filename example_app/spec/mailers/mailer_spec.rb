require "spec_helper"

describe Mailer, '#completion_notification' do
  it 'should set the correct recipient' do
    completion_notification.should deliver_to('email@example.com')
  end

  it 'should set the correct subject' do
    completion_notification.should have_subject('Thank you for completing the survey')
  end

  it 'should set the correct body' do
    completion_notification.should have_body_text(/First Last/)
  end

  def completion_notification
    Mailer.completion_notification(build_user)
  end

  def build_user
    build(:user, email: 'email@example.com', first_name: 'First', last_name: 'Last')
  end
end

describe Mailer, '#invitation_notification' do
  it 'sets the correct recipient' do
    message.should deliver_to(recipient_email)
  end

  it 'sets the correct subject' do
    message.should have_subject('You have been invited to take an online survey')
  end

  it 'uses the given body' do
    message.should have_body_text(body_text)
  end

  def message
    Mailer.invitation_notification(invitation, body_text)
  end

  def invitation
    @invitation ||= build(
      :invitation,
      token: 'unique_token',
      recipient_email: recipient_email,
      message: invitation_text
    )
  end

  def invitation_path
    new_invitation_user_url(invitation)
  end

  def recipient_email
    'tester@example.com'
  end

  def invitation_text
    'Fill out this survey'
  end

  def body_text
    'example body text'
  end
end
