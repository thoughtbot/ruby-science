class MessageInviter
  include Inviter

  def initialize(invitation, recipient)
    @invitation = invitation
    @recipient = recipient
  end

  def deliver
    Message.create!(
      recipient: @recipient,
      sender: @invitation.sender,
      body: render_message_body
    )
  end
end
