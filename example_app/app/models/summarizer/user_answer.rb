class Summarizer::UserAnswer
  include Summarizer::Base

  def initialize(options)
    @user = options[:user]
  end

  private

  def summary_value(question)
    @user.answer_text_for(question)
  end
end
