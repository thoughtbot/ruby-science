require 'spec_helper'

describe UnsubscribeableMailer, '#deliver' do
  it 'sends email notifications to new users' do
    invitation = create(:invitation)

    deliver_invitation invitation, 'body'

    find_email(invitation.recipient_email).should have_body_text('body')
  end

  it 'sends nothing to users that have unsubscribed' do
    invitation = create(:invitation)
    unsubscribe = create(:unsubscribe, email: invitation.recipient_email)

    deliver_invitation invitation, 'body'

    find_email(invitation.recipient_email).should be_nil
  end

  def deliver_invitation(invitation, body)
    UnsubscribeableMailer.invitation_notification(invitation, body).deliver
  end
end
