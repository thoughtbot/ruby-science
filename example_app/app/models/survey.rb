class Survey < ActiveRecord::Base
  NO_ANSWER = "You haven't answered this question".freeze

  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :title

  belongs_to :author, class_name: 'User'
  has_many :completions
  has_many :questions

  def summaries_using(summarizer, options = {})
    questions.map do |question|
      summary_or_hidden_answer(summarizer, question, options)
    end
  end

  private

  def summary_or_hidden_answer(summarizer, question, options)
    if hide_unanswered_question?(question, options[:answered_by])
      hide_answer_to_question(question)
    else
      question.summary_using(summarizer, options)
    end
  end

  def hide_unanswered_question?(question, answered_by)
    answered_by && !question.answered_by?(answered_by)
  end

  def hide_answer_to_question(question)
    Summary.new(question.title, NO_ANSWER)
  end
end
