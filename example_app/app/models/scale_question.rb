class ScaleQuestion < Question
  validates :maximum, presence: true
  validates :minimum, presence: true

  def steps
    (minimum..maximum).to_a
  end

  def summary
    sprintf('Average: %.02f', answers.average('text'))
  end
end
