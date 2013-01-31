class MultipleChoiceSubmittable
  def initialize(question)
    @question = question
  end

  def breakdown
    total = answers.count
    counts = answers.group(:text).order('COUNT(*) DESC').count
    percents = counts.map do |text, count|
      percent = (100.0 * count / total).round
      "#{percent}% #{text}"
    end
    percents.join(', ')
  end

  def score(text)
    options.score(text)
  end

  private

  def answers
    @question.answers
  end

  def options
    @question.options
  end
end
