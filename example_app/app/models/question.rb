class Question < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  QUESTION_TYPES = %w(OpenQuestion MultipleChoiceQuestion ScaleQuestion).freeze

  validates :type, presence: true, inclusion: QUESTION_TYPES
  validates :title, presence: true

  belongs_to :submittable, polymorphic: true
  belongs_to :survey
  has_many :answers

  delegate :breakdown, :score, to: :submittable
  delegate :title, to: :survey, prefix: true

  def most_recent_answer_text
    answers.most_recent.text
  end

  def build_submittable
    submittable_class = type.sub('Question', 'Submittable').constantize
    self.submittable = submittable_class.new(question: self)
  end

  def summarize(summarizer)
    value = summarizer.summarize(self)
    Summary.new(title, value)
  end

  def switch_to(type, new_attributes)
    attributes = self.attributes.merge(new_attributes)
    cloned_attributes = attributes.except('id', 'type', 'submittable_type')
    new_question = type.constantize.new(cloned_attributes)
    new_question.build_submittable
    new_question.id = id

    begin
      Question.transaction do
        destroy
        new_question.save!
      end
    rescue ActiveRecord::RecordInvalid
    end

    new_question
  end
end
