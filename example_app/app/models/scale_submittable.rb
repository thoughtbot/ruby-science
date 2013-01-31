class ScaleSubmittable
  def initialize(question)
    @question = question
  end

  def breakdown
    sprintf('Average: %.02f', answers.average('text'))
  end

  def score(text)
    text.to_i
  end

  private

  def answers
    @question.answers
  end
end
