class Summarizer::MostRecent
  def initialize(options)
  end

  def summarize(question)
    question.most_recent_answer_text
  end
end
