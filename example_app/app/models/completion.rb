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

  def breakdown
    summarizer = Summarizer::Breakdown.new({})
    survey.summaries_using(summarizer)
  end

  def score
    answers.inject(0) do |result, answer|
      result + answer.score
    end
  end

  private

  def completion_notification
    Mailer.completion_notification(user).deliver
  end
end
