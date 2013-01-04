class OpenQuestion < Question
  def score(text)
    0
  end

  def summary
    text_from_ordered_answers = answers.order(:created_at).pluck(:text)
    text_from_ordered_answers.join(', ')
  end
end
