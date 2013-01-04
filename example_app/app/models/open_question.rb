class OpenQuestion < Question
  def score(text)
    0
  end

  def summary
    # Text for each answer in order as a comma-separated string
    answers.order(:created_at).pluck(:text).join(', ')
  end
end
