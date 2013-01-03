class Completion < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :survey
  belongs_to :user
  has_many :answers

  after_create :completion_notification

  def answers_attributes=(answers_attributes)
    answers_attributes.each do |question_id, answer_attributes|
      answers.build(answer_attributes.merge(question_id: question_id))
    end
  end

  def score
    answers.inject(0) do |result, answer|
      result + score_for_answer(answer)
    end
  end

  private

  def completion_notification
    Mailer.completion_notification(user).deliver
  end

  def score_for_answer(answer)
    question = answer.question
    question.score(answer.text)
  end
end
