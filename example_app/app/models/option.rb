class Option < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :question

  validates :text, presence: true

  def self.score(text)
    find_by_text!(text).score
  end
end
