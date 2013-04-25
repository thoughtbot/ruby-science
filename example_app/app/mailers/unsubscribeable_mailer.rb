class UnsubscribeableMailer
  def self.invitation_notification(invitation, body)
    if unsubscribed?(invitation)
      NullMessage.new
    else
      Mailer.invitation_notification(invitation, body)
    end
  end

  private

  def self.unsubscribed?(invitation)
    Unsubscribe.where(email: invitation.recipient_email).exists?
  end

  class NullMessage
    def deliver
    end
  end
end
