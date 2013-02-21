class UnansweredQuestionHider
  NO_ANSWER = "You haven't answered this question".freeze

  def initialize(summarizer, user)
    @summarizer = summarizer
    @user = user
  end

  def summarize(question)
    if hide_unanswered_question?(question)
      hide_answer_to_question(question)
    else
      @summarizer.summarize(question)
    end
  end

  private

  def hide_answer_to_question(question)
    NO_ANSWER
  end

  def hide_unanswered_question?(question)
    @user && !question.answered_by?(@user)
  end
end
