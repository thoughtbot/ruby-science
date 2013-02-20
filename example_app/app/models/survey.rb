class Survey < ActiveRecord::Base
  NO_ANSWER = "You haven't answered this question".freeze

  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :title

  belongs_to :author, class_name: 'User'
  has_many :completions
  has_many :questions

  def summarize(summarizer, options = {})
    questions.map do |question|
      if !options[:answered_by] || question.answered_by?(options[:answered_by])
        question.summarize(summarizer)
      else
        Summary.new(question.title, NO_ANSWER)
      end
    end
  end
end
