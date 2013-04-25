require 'spec_helper'

describe UnsubscribeableInvitation, '#deliver' do
  include Rails.application.routes.url_helpers
  self.default_url_options = ActionMailer::Base.default_url_options

  it 'sends email notifications to new users' do
    invitation = deliver_invitation

    find_email(invitation.recipient_email).
      should have_body_text(invitation.message)
  end

  it 'sends nothing to users that have unsubscribed' do
    unsubscribe = create(:unsubscribe)
    deliver_invitation(recipient_email: unsubscribe.email)

    find_email(unsubscribe.email).should be_nil
  end

  def deliver_invitation(overrides = {})
    InvitationDeliverer.new(UnsubscribeableInvitation).
      deliver_invitation(overrides)
  end
end
