class UserAnswer
  def initialize(user)
    @user = user
  end

  def summarize(question)
    @user.answer_text_for question
  end
end
