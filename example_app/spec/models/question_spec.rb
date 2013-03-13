require 'spec_helper'

describe Question do
  it { should validate_presence_of :submittable_type }

  Question::QUESTION_TYPES.each do |type|
    it { should allow_value(type).for(:submittable_type) }
  end

  it { should_not allow_value('Other').for(:submittable_type) }

  it { should validate_presence_of :title }

  it { should belong_to(:submittable) }
  it { should belong_to(:survey) }
  it { should have_many(:answers) }
end

describe Question, '#answered_by?' do
  it 'returns true for a user with an answer' do
    user = create(:user)
    question = create(:question)
    AnswerCreator.new(question.survey, user: user).answer(question)

    question.should be_answered_by(user)
  end

  it 'returns false for a user without an answer' do
    user = create(:user)
    other_user = create(:user)
    survey = create(:survey)
    question = create(:question, survey: survey)
    other_question = create(:question, survey: survey)
    creator = AnswerCreator.new(survey, user: user)
    creator.answer(question, '')
    creator.answer(other_question, 'hello')
    AnswerCreator.new(survey, user: other_user).answer(question)

    question.should_not be_answered_by(user)
  end
end

describe Question, '#build_submittable' do
  it 'builds a submittable with the given type and attributes' do
    expected_value = 1.day.ago
    question = build(:question)

    question.build_submittable('OpenSubmittable', created_at: expected_value)

    question.submittable.created_at.should eq expected_value
    question.submittable.should be_a(OpenSubmittable)
  end
end

describe Question, '#most_recent_answer_text' do
  it 'returns the text for the latest answer' do
    question = create(:open_question)
    create(:answer, question: question, text: 'middle', created_at: 2.days.ago)
    create(:answer, question: question, text: 'newest', created_at: 1.day.ago)
    create(:answer, question: question, text: 'oldest', created_at: 3.days.ago)

    result = question.most_recent_answer_text

    result.should eq 'newest'
  end

  it 'returns text without any answers' do
    question = create(:open_question)

    result = question.most_recent_answer_text

    result.should be_present
  end
end

describe Question, '#summary_using' do
  it 'builds a summary with the result from the summarizer' do
    question = build_stubbed(:question)
    summarizer = stub('summarizer', summarize: 'result')

    summary = question.summary_using(summarizer)

    summary.title.should eq question.title
    summary.value.should eq 'result'
  end
end

describe Question, '#switch_to' do
  it 'changes the question type and deletes the old question when valid' do
    question = create(:open_question)

    question.switch_to(
      'ScaleQuestion',
      { minimum: 1, maximum: 2 }
    )

    question.errors.should be_empty
    submittable = question.submittable
    submittable.should be_a(ScaleSubmittable)
    submittable.minimum.should eq 1
    submittable.maximum.should eq 2
    Question.count.should eq 1
    OpenSubmittable.count.should eq 0
  end

  it 'leaves the question alone when the new attributes are invalid' do
    question = create(:open_question)

    question.switch_to('ScaleQuestion', { minimum: 1 })

    question.errors.should be_present
    question.submittable.should be_a(ScaleSubmittable)
    question.submittable.minimum.should eq 1
  end
end
