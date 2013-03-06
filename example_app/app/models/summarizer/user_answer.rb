class Summarizer::UserAnswer
  def initialize(options)
    @user = options[:user]
  end

  def summarize(question)
    Summary.new(question.title, @user.answer_text_for(question))
  end
end
