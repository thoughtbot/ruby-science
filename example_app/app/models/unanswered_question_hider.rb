class UnansweredQuestionHider
  NO_ANSWER = "You haven't answered this question".freeze

  def initialize(summarizer, user)
    @summarizer = summarizer
    @user = user
  end

  def summarize(question)
    if hide_unanswered_question?(question)
      NO_ANSWER
    else
      @summarizer.summarize(question)
    end
  end

  private

  def hide_unanswered_question?(question)
    !question.answered_by?(@user)
  end
end
