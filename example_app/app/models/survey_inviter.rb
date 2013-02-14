class SurveyInviter
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  def initialize(message, recipients)
    @message = message
    @recipients = recipients
  end

  def valid?
    valid_message? && valid_recipients?
  end

  def invalid_recipients
    @invalid_recipients ||= recipient_list.map do |item|
      unless item.match(EMAIL_REGEX)
        item
      end
    end.compact
  end

  def recipient_list
    @recipient_list ||= @recipients.gsub(/\s+/, '').split(/[\n,;]+/)
  end

  private

  def valid_message?
    @message.present?
  end

  def valid_recipients?
    invalid_recipients.empty?
  end
end
