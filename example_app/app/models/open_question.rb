class OpenQuestion < Question
  def summary
    answers.order(:created_at).pluck(:text).join(', ')
  end
end
