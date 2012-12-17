class Invitation < ActiveRecord::Base
  STATUSES = %w(pending accepted)

  belongs_to :sender, class_name: 'User'
  belongs_to :survey
  before_create :set_token

  validates :recipient_email, presence: true
  validates :status, inclusion: { in: STATUSES }

  def to_param
    token
  end

  private

  def set_token
    self.token = SecureRandom.urlsafe_base64
  end
end
