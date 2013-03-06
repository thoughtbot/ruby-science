class Inviter
  private

  def render_message_body
    InvitationMessage.new(@invitation).body
  end
end
