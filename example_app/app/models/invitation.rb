class Invitation < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  STATUSES = %w(pending accepted)

  belongs_to :sender, class_name: 'User'
  belongs_to :survey

  before_create :set_token

  validates :recipient_email, presence: true, format: EMAIL_REGEX
  validates :status, inclusion: { in: STATUSES }

  def to_param
    token
  end

  def deliver
    if recipient_user
      MessageInviter.new(self, recipient_user).deliver
    else
      EmailInviter.new(self).deliver
    end
  end

  private

  def set_token
    self.token = SecureRandom.urlsafe_base64
  end

  def recipient_user
    User.find_by_email(recipient_email)
  end
end
