class EmailInviter < Inviter
  def initialize(invitation)
    @invitation = invitation
  end

  def deliver
    Mailer.invitation_notification(@invitation, render_message_body).deliver
  end
end
