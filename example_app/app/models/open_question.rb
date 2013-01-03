class OpenQuestion < Question
  def score(text)
    0
  end

  def summary
    answers.order(:created_at).pluck(:text).join(', ')
  end
end
