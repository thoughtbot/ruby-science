require 'spec_helper'

describe Question do
  it { should validate_presence_of :type }

  Question::QUESTION_TYPES.each do |type|
    it { should allow_value(type).for(:type) }
  end

  it { should_not allow_value('Other').for(:type) }

  it { should validate_presence_of :title }

  it { should belong_to(:survey) }
  it { should have_many(:answers) }
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
