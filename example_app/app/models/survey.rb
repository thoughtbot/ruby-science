class Survey < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :title

  belongs_to :author, class_name: 'User'
  has_many :completions
  has_many :questions

  def summaries_using(summarizer)
    questions.map do |question|
      question.summarize(summarizer)
    end
  end
end
