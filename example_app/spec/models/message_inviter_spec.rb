require 'spec_helper'

describe MessageInviter, '#deliver' do
  include Rails.application.routes.url_helpers
  self.default_url_options = ActionMailer::Base.default_url_options

  it 'creates a message for the invitation' do
    survey = create(:survey)
    invitation = create(:invitation, message: 'hello', survey: survey)
    recipient = create(:user)
    inviter = MessageInviter.new(invitation, recipient)

    inviter.deliver

    Message.count.should eq 1
    message = Message.last
    message.sender.should eq invitation.sender
    message.recipient.should eq recipient
    message.body.should include(invitation.message)
    message.body.should include(survey_url(survey))
  end
end
