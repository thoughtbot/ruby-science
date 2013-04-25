class SurveyInviter
  include ActiveModel::Model
  attr_accessor :recipients, :message, :sender, :survey

  validates :message, presence: true
  validates :recipients, length: { minimum: 1 }
  validates :sender, presence: true
  validates :survey, presence: true

  validates_with EnumerableValidator,
    attributes: [:recipients],
    unless: 'recipients.nil?',
    validator: EmailValidator

  def recipients=(recipients)
    @recipients = RecipientList.new(recipients)
  end

  def invite
    if valid?
      deliver_invitations
    end
  end

  private

  def deliver_invitations
    create_invitations.each do |invitation|
      invitation.deliver(UnsubscribeableMailer)
    end
  end

  def create_invitations
    Invitation.transaction do
      recipients.map do |recipient_email|
        Invitation.create!(
          survey: survey,
          sender: sender,
          recipient_email: recipient_email,
          status: 'pending',
          message: @message
        )
      end
    end
  end
end
