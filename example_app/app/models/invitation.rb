class Invitation < ActiveRecord::Base
  STATUSES = %w(pending accepted)

  belongs_to :sender, class_name: 'User'
  belongs_to :survey

  before_create :set_token

  validates :recipient_email, presence: true, email_address: true
  validates :status, inclusion: { in: STATUSES }

  def to_param
    token
  end

  def deliver(mailer)
    body = InvitationMessage.new(self).body
    mailer.invitation_notification(self, body).deliver_now
  end

  private

  def set_token
    self.token = SecureRandom.urlsafe_base64
  end
end
