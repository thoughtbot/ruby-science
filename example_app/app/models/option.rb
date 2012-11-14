class Option < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :question

  validates :text, presence: true
end
