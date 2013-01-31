class ScaleQuestion < Question
  validates :maximum, presence: true
  validates :minimum, presence: true

  def submittable
    ScaleSubmittable.new(self)
  end
end
