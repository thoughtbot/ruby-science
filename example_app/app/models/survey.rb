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
    if hide_unanswered_question?(question, answered_by)
      UnansweredQuestionHider.new.hide_answer_to_question(question)
    else
      question.summary_using(summarizer)
    end
  end

  def hide_unanswered_question?(question, answered_by)
    answered_by && !question.answered_by?(answered_by)
  end
end
