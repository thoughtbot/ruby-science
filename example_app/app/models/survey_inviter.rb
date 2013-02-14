class SurveyInviter
  def initialize(recipients)
    @recipients = recipients
  end

  def recipient_list
    @recipient_list ||= @recipients.gsub(/\s+/, '').split(/[\n,;]+/)
  end
end
