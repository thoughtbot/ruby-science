class Question < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  SUBMITTABLE_TYPES = %w(Open MultipleChoice Scale).freeze

  validates :maximum, presence: true, if: :scale?
  validates :minimum, presence: true, if: :scale?
  validates :question_type, presence: true, inclusion: SUBMITTABLE_TYPES
  validates :title, presence: true

  belongs_to :survey
  has_many :answers
  has_many :options

  accepts_nested_attributes_for :options, reject_if: :all_blank

  def summary
    case question_type
    when 'MultipleChoice'
      summarize_multiple_choice_answers
    when 'Open'
      summarize_open_answers
    when 'Scale'
      summarize_scale_answers
    end
  end

  def steps
    (minimum..maximum).to_a
  end

  private

  def scale?
    question_type == 'Scale'
  end

  def summarize_multiple_choice_answers
    total = answers.count
    counts = answers.group(:text).order('COUNT(*) DESC').count
    percents = counts.map do |text, count|
      percent = (100.0 * count / total).round
      "#{percent}% #{text}"
    end
    percents.join(', ')
  end

  def summarize_open_answers
    answers.order(:created_at).pluck(:text).join(', ')
  end

  def summarize_scale_answers
    sprintf('Average: %.02f', answers.average('text'))
  end
end
