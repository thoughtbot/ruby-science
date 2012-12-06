class Question < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  QUESTION_TYPES = %w(OpenQuestion MultipleChoiceQuestion ScaleQuestion).freeze

  validates :type, presence: true, inclusion: QUESTION_TYPES
  validates :title, presence: true

  belongs_to :survey
  has_many :answers

  delegate :title, to: :survey, prefix: true

  def most_recent_answer_text
    answers.most_recent.text
  end
end
