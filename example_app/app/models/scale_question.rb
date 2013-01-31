class ScaleQuestion < Question
  validates :maximum, presence: true
  validates :minimum, presence: true

  def steps
    submittable.steps
  end

  def submittable
    ScaleSubmittable.new(self)
  end
end
