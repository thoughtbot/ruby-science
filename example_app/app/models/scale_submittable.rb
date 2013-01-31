class ScaleSubmittable < ActiveRecord::Base
  has_one :question, as: :submittable

  def breakdown
    sprintf('Average: %.02f', answers.average('text'))
  end

  def score(text)
    text.to_i
  end

  def steps
    (question.minimum..question.maximum).to_a
  end

  private

  def answers
    question.answers
  end
end
