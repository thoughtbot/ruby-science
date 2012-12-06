class Answer < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  MISSING_TEXT = 'No response'.freeze

  belongs_to :completion
  belongs_to :question

  validates :text, presence: true

  def self.for_user(user)
    joins(:completion).where(completions: { user_id: user.id }).last
  end

  def self.most_recent
    order(:created_at).last
  end
end
