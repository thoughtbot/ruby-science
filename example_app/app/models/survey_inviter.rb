class SurveyInviter
  include ActiveModel::Model
  attr_accessor :recipients, :message, :sender, :survey
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates :message, presence: true
  validates :recipients, presence: true
  validates :sender, presence: true
  validates :survey, presence: true

  validate :recipient_email_validator

  def recipients=(recipients)
    unless recipients.blank?
      @recipients = RecipientList.new(recipients)
    end
  end

  def invite
    if valid?
      deliver_invitations
    end
  end

  private

  def create_invitations
    recipients.map do |recipient_email|
      Invitation.create!(
        survey: survey,
        sender: sender,
        recipient_email: recipient_email,
        status: 'pending'
      )
    end
  end

  def deliver_invitations
    create_invitations.each do |invitation|
      Mailer.invitation_notification(invitation, message).deliver
    end
  end

  def recipient_email_validator
    return if recipients.blank?

    recipients.each do |recipient|
      unless recipient.match(EMAIL_REGEX)
        errors.add(:recipients, "#{recipient} is not a valid email address.")
      end
    end
  end
end
