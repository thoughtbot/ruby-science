class SurveyInviter
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  def initialize(attributes = {})
    @survey = attributes[:survey]
    @message = attributes[:message] || ''
    @recipients = attributes[:recipients] || ''
    @sender = attributes[:sender]
  end

  def valid?
    valid_message? && valid_recipients?
  end

  def deliver
    recipient_list.each do |email|
      invitation = Invitation.create(
        survey: @survey,
        sender: @sender,
        recipient_email: email,
        status: 'pending'
      )
      Mailer.invitation_notification(invitation, @message)
    end
  end

  def invalid_recipients
    @invalid_recipients ||= recipient_list.map do |item|
      unless item.match(EMAIL_REGEX)
        item
      end
    end.compact
  end

  private

  def valid_message?
    @message.present?
  end

  def valid_recipients?
    invalid_recipients.empty?
  end

  def recipient_list
    @recipient_list ||= @recipients.gsub(/\s+/, '').split(/[\n,;]+/)
  end
end
