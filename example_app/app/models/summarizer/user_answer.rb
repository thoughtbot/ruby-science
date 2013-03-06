class Summarizer::UserAnswer
  def initialize(options)
    @user = options[:user]
  end

  def summarize(question)
    @user.answer_text_for question
  end
end
