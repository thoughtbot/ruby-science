class Summarizer::MostRecent
  def initialize(options)
  end

  def summarize(question)
    Summary.new(question.title, question.most_recent_answer_text)
  end
end
