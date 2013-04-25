class UnsubscribeableInvitation < Invitation
  def deliver
    unless unsubscribed?
      super
    end
  end

  private

  def unsubscribed?
    Unsubscribe.where(email: recipient_email).exists?
  end
end
