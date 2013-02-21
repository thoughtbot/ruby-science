class Survey < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :title

  belongs_to :author, class_name: 'User'
  has_many :completions
  has_many :questions

  def summaries_using(summarizer, options = {})
    questions.map do |question|
      summary_or_hidden_answer(summarizer, question, options[:answered_by])
    end
  end

  private

  def summary_or_hidden_answer(summarizer, question, answered_by)
    hider = UnansweredQuestionHider.new
    if hider.hide_unanswered_question?(question, answered_by)
      hider.hide_answer_to_question(question)
    else
      question.summary_using(summarizer)
    end
  end
end
