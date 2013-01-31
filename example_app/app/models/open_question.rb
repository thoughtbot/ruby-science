class OpenQuestion < Question
  def score(text)
    submittable.score(text)
  end

  def breakdown
    text_from_ordered_answers = answers.order(:created_at).pluck(:text)
    text_from_ordered_answers.join(', ')
  end

  def submittable
    OpenSubmittable.new
  end
end
