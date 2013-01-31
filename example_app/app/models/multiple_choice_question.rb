class MultipleChoiceQuestion < Question
  has_many :options, foreign_key: :question_id

  accepts_nested_attributes_for :options, reject_if: :all_blank
end
