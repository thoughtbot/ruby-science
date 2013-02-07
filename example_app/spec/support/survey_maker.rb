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

    submittable = create(
      :multiple_choice_submittable,
      options: options
    )

    create(
      :multiple_choice_question,
      submittable: submittable,
      survey: survey,
      title: title
    )
  end

  def scale_question(title, range)
    submittable = create(
      :scale_submittable,
      minimum: range.first,
      maximum: range.last
    )
    create(
      :scale_question,
      submittable: submittable,
      survey: survey,
      title: title
    )
  end

  def survey
    @survey ||= create(:survey)
  end
end
