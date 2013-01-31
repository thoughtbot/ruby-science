class ScaleQuestion < Question
  validates :maximum, presence: true
  validates :minimum, presence: true
end
