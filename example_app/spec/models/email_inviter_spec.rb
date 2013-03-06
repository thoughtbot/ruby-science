require 'spec_helper'

describe EmailInviter, '#deliver' do
  include Rails.application.routes.url_helpers
  self.default_url_options = ActionMailer::Base.default_url_options

  it 'creates a message for the invitation' do
    survey = create(:survey)
    invitation = create(:invitation, message: 'hello', survey: survey)
    recipient = create(:user)
    inviter = EmailInviter.new(invitation)

    inviter.deliver

    message = ActionMailer::Base.deliveries.last
    message.should deliver_to(invitation.recipient_email)
    message.should have_body_text(invitation.sender.email)
    message.should have_body_text(invitation.message)
    message.should have_body_text(survey_url(survey))
  end
end
