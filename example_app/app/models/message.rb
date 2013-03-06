class Message < ActiveRecord::Base
  belongs_to :recipient, class_name: 'User'
  belongs_to :sender, class_name: 'User'

  validates :body, presence: true
  validates :recipient_id, presence: true
  validates :sender_id, presence: true
end
