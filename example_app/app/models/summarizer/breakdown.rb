class Summarizer::Breakdown
  def initialize(options)
  end

  def summarize(question)
    Summary.new(question.title, question.breakdown)
  end
end
