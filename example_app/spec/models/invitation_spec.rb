require 'spec_helper'

describe Invitation, 'Associations' do
  it { should belong_to(:sender) }
  it { should belong_to(:survey) }
end

describe Invitation, 'Validations' do
  it { should validate_presence_of(:recipient_email) }
  it { should allow_value('user@example.com').for(:recipient_email) }
  it { should_not allow_value('invalid_email').for(:recipient_email) }
  it { should ensure_inclusion_of(:status).in_array(Invitation::STATUSES) }
end

describe Invitation, '#deliver' do
  include Rails.application.routes.url_helpers
  self.default_url_options = ActionMailer::Base.default_url_options

  it 'sends email notifications to new users' do
    survey = create(:survey)
    invitation = create(:invitation, message: 'hello', survey: survey)

    invitation.deliver

    message = ActionMailer::Base.deliveries.last
    message.should deliver_to(invitation.recipient_email)
    message.should have_body_text(invitation.sender.email)
    message.should have_body_text(invitation.message)
    message.should have_body_text(survey_url(survey))
  end
end

describe Invitation, '#to_param' do
  it 'returns the invitation token' do
    invitation = create(:invitation)

    invitation.to_param.should eq invitation.token
  end
end
