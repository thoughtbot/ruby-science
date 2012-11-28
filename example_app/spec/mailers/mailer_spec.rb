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

  private

  def completion_notification
    Mailer.completion_notification(build_user)
  end

  def build_user
    build(:user, email: 'email@example.com', first_name: 'First', last_name: 'Last')
  end
end
