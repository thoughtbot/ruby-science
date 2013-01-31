class MultipleChoiceSubmittable
  def initialize(question)
    @question = question
  end

  def score(text)
    options.score(text)
  end

  private

  def options
    @question.options
  end
end
