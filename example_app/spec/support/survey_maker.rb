class SurveyMaker
  include FactoryGirl::Syntax::Methods

  def open_question(title)
    create :open_question, title: title, survey: survey
  end

  def multiple_choice_question(title, *options)
    create(
      :multiple_choice_question,
      title: title,
      options_texts: options,
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
