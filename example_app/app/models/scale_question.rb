class ScaleQuestion < Question
  validates :maximum, presence: true
  validates :minimum, presence: true

  def score(text)
    text.to_i
  end

  def steps
    (minimum..maximum).to_a
  end

  def summary
    sprintf('Average: %.02f', answers.average('text'))
  end
end
