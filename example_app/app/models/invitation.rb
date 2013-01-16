class Invitation < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  STATUSES = %w(pending accepted)

  belongs_to :sender, class_name: 'User'
  belongs_to :survey

  before_create :set_token
  after_create :deliver

  validates :recipient_email, presence: true, format: EMAIL_REGEX
  validates :status, inclusion: { in: STATUSES }

  def to_param
    token
  end

  private

  def deliver
    Mailer.invitation_notification(self).deliver
  end

  def set_token
    self.token = SecureRandom.urlsafe_base64
  end
end
