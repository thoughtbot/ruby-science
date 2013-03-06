module Summarizer::Base
  def summarize(question)
    Summary.new(question.title, summary_value(question))
  end
end
