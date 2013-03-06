class Summarizer::Breakdown
  include Summarizer::Base

  def initialize(options)
  end

  private

  def summary_value(question)
    question.breakdown
  end
end
