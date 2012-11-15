class Completion < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :survey
  belongs_to :user
  has_many :answers

  def answers_attributes=(answers_attributes)
    answers_attributes.each do |question_id, answer_attributes|
      answers.build(answer_attributes.merge(question_id: question_id))
    end
  end
end
