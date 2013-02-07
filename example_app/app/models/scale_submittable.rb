class ScaleSubmittable < ActiveRecord::Base
  has_one :question, as: :submittable

  validates :maximum, presence: true
  validates :minimum, presence: true

  def breakdown
    sprintf('Average: %.02f', answers.average('text'))
  end

  def score(text)
    text.to_i
  end

  def steps
    (minimum..maximum).to_a
  end

  private

  def answers
    question.answers
  end
end
