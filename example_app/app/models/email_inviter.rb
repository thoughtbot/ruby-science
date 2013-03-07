class EmailInviter
  def initialize(invitation)
    @invitation = invitation
    @body = InvitationMessage.new(@invitation).body
  end

  def deliver
    Mailer.invitation_notification(@invitation, @body).deliver
  end
end
