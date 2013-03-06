require 'spec_helper'

describe InvitationMessage, '#body' do
  include Rails.application.routes.url_helpers
  self.default_url_options = ActionMailer::Base.default_url_options

  it 'renders the invitation message template' do
    survey = build_stubbed(:survey)
    invitation = create(:invitation, message: 'hello', survey: survey)
    message = InvitationMessage.new(invitation)

    message.body.should include(invitation.message)
    message.body.should include(survey_url(survey))
  end
end
