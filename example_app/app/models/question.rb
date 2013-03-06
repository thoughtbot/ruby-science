class Question < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  QUESTION_TYPES = %w(
    OpenSubmittable
    MultipleChoiceSubmittable
    ScaleSubmittable
  ).freeze

  validates :submittable, associated: true
  validates :submittable_type, presence: true, inclusion: QUESTION_TYPES
  validates :title, presence: true

  belongs_to :submittable, polymorphic: true
  belongs_to :survey
  has_many :answers

  accepts_nested_attributes_for :submittable

  delegate :breakdown, :score, to: :submittable
  delegate :title, to: :survey, prefix: true

  def answered_by?(user)
    answers.
      joins(:completion).
      where(completions: { user_id: user }).
      where("answers.text <> ''").
      exists?
  end

  def most_recent_answer_text
    answers.most_recent.text
  end

  def build_submittable(type, attributes)
    submittable_class = type.sub('Question', 'Submittable').constantize
    self.submittable = submittable_class.new(attributes.merge(question: self))
  end

  def summary_using(summarizer)
    value = summarizer.summarize(self)
    Summary.new(title, value)
  end

  def switch_to(type, attributes)
    old_submittable = submittable
    build_submittable type, attributes

    transaction do
      if save
        old_submittable.destroy
      end
    end
  end
end
