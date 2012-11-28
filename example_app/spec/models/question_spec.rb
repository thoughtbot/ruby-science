require 'spec_helper'

describe Question do
  it { should validate_presence_of :question_type }

  Question::SUBMITTABLE_TYPES.each do |type|
    it { should allow_value(type).for(:question_type) }
  end

  it { should_not allow_value('Other').for(:question_type) }

  it { should validate_presence_of :title }

  it { should belong_to(:survey) }
  it { should have_many(:answers) }
  it { should have_many(:options) }

  context 'scale' do
    subject { build_stubbed(:scale_question) }

    it { should validate_presence_of(:maximum) }
    it { should validate_presence_of(:minimum) }
  end
end

describe Question, '#steps' do
  it 'returns all numbers starting at the minimum and ending at the maximum' do
    question = build_stubbed(:scale_question, minimum: 2, maximum: 5)
    question.steps.should eq [2, 3, 4, 5]
  end
end

describe Question, '#summary' do
  it 'returns all answers to open questions' do
    question = create(:open_question)
    answer question, 'Hey'
    answer question, 'Hi'
    answer question, 'Hello'

    question.summary.should eq 'Hey, Hi, Hello'
  end

  it 'returns a percentage breakdown for multiple choice questions' do
    question = create(:multiple_choice_question, options_texts: %w(Blue Red))
    answer question, 'Red'
    answer question, 'Blue'
    answer question, 'Red'

    question.summary.should eq '67% Red, 33% Blue'
  end

  it 'returns the average for scale questions' do
    question = create(:scale_question, minimum: 0, maximum: 10)
    answer question, 6
    answer question, 6
    answer question, 8

    question.summary.should eq 'Average: 6.67'
  end

  def answer(question, answer_text)
    create(:answer, question: question, text: answer_text)
  end
end
