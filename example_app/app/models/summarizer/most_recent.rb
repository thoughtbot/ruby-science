class Summarizer::MostRecent
  include Summarizer::Base

  def initialize(options)
  end

  private

  def summary_value(question)
    question.most_recent_answer_text
  end
end
