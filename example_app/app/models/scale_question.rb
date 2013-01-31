class ScaleQuestion < Question
  validates :maximum, presence: true
  validates :minimum, presence: true

  def steps
    (minimum..maximum).to_a
  end

  def submittable
    ScaleSubmittable.new(self)
  end
end
