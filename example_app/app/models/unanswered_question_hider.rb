class UnansweredQuestionHider
  NO_ANSWER = "You haven't answered this question".freeze

  def hide_answer_to_question(question)
    Summary.new(question.title, NO_ANSWER)
  end

  def hide_unanswered_question?(question, user)
    user && !question.answered_by?(user)
  end
end
