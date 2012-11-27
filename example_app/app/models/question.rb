class Question < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  SUBMITTABLE_TYPES = %w(Open MultipleChoice Scale).freeze

  validates :maximum, presence: true, if: :scale?
  validates :minimum, presence: true, if: :scale?
  validates :submittable_type, presence: true, inclusion: SUBMITTABLE_TYPES
  validates :title, presence: true

  belongs_to :survey
  has_many :options

  accepts_nested_attributes_for :options, reject_if: :all_blank

  def steps
    (minimum..maximum).to_a
  end

  private

  def scale?
    submittable_type == 'Scale'
  end
end
