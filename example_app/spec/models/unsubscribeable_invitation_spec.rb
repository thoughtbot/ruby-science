require 'spec_helper'

describe UnsubscribeableInvitation, '#deliver' do
  it 'sends email notifications to new users' do
    invitation = stub_invitation

    deliver_invitation invitation

    invitation.should have_received(:deliver)
  end

  it 'sends nothing to users that have unsubscribed' do
    invitation = stub_invitation
    unsubscribe = create(:unsubscribe, email: invitation.recipient_email)

    deliver_invitation invitation

    invitation.should have_received(:deliver).never
  end

  def stub_invitation
    stub('invitation', deliver: true, recipient_email: generate(:email))
  end

  def deliver_invitation(invitation)
    UnsubscribeableInvitation.new(invitation).deliver
  end
end
