class SurveyMaker
  include FactoryGirl::Syntax::Methods

  def open_question(title)
    create :open_question, title: title, survey: survey
  end

  def multiple_choice_question(title, *texts)
    texts_and_scores = texts.inject({}) do |result, text|
      result.update(text => 0)
    end

    scored_multiple_choice_question title, texts_and_scores
  end

  def scored_multiple_choice_question(title, texts_and_scores)
    options = texts_and_scores.map do |(text, score)|
      build(:option, text: text, score: score)
    end

    create(
      :multiple_choice_question,
      title: title,
      options: options,
      survey: survey
    )
  end

  def scale_question(title, range)
    create(
      :scale_question,
      title: title,
      minimum: range.first,
      maximum: range.last,
      survey: survey
    )
  end

  def survey
    @survey ||= create(:survey)
  end
end
