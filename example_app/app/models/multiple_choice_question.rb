class MultipleChoiceQuestion < Question
  has_many :options, foreign_key: :question_id

  accepts_nested_attributes_for :options, reject_if: :all_blank

  def options_for_form
    if options.any?
      options
    else
      [Option.new, Option.new, Option.new]
    end
  end

  def summary
    total = answers.count
    counts = answers.group(:text).order('COUNT(*) DESC').count
    percents = counts.map do |text, count|
      percent = (100.0 * count / total).round
      "#{percent}% #{text}"
    end
    percents.join(', ')
  end
end
