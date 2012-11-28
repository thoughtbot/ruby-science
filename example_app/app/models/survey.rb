class Survey < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :title

  has_many :completions
  has_many :questions
end
