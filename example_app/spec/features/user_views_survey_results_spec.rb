feature 'user views survey results' do
  include SurveySupport

  scenario 'view survey results' do
    sign_in
    survey = create(:survey)
    create(
      :open_question,
      title: 'What is your name?',
      survey: survey
    )
    create(
      :multiple_choice_question,
      title: 'What is your favorite color?',
      options_texts: %w(Red Blue),
      survey: survey
    )
    create(
      :scale_question,
      title: 'What is the airspeed velocity of a sparrow?',
      minimum: 0,
      maximum: 10,
      survey: survey
    )

    view_survey survey
    fill_in 'What is your name?', with: 'Brian'
    choose 'Red'
    choose '10'
    submit_answers

    view_survey survey
    fill_in 'What is your name?', with: 'Billy'
    choose 'Red'
    choose '10'
    submit_answers

    view_survey survey
    fill_in 'What is your name?', with: 'Benny'
    choose 'Blue'
    choose '4'
    submit_answers

    open_answer = summary_for_question('What is your name?')
    open_answer.should have_content('Brian')
    open_answer.should have_content('Billy')
    open_answer.should have_content('Benny')

    multiple_choice_answer = summary_for_question('What is your favorite color?')
    multiple_choice_answer.should have_content('67% Red')
    multiple_choice_answer.should have_content('33% Blue')

    slider_answer = summary_for_question('What is the airspeed velocity of a sparrow?')
    slider_answer.should have_content('Average: 8')
  end

  def summary_for_question(question)
    page.find('.summary li', text: question)
  end
end
