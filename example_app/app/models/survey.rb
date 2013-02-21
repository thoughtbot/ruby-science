class Survey < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :title

  belongs_to :author, class_name: 'User'
  has_many :completions
  has_many :questions

  def summaries_using(summarizer, options = {})
    questions.map do |question|
      UnansweredQuestionHider.new(summarizer, options[:answered_by]).
        summary_or_hidden_answer(question)
    end
  end
end
