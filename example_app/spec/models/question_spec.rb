require 'spec_helper'

describe Question do
  it { should validate_presence_of :submittable_type }

  Question::SUBMITTABLE_TYPES.each do |type|
    it { should allow_value(type).for(:submittable_type) }
  end

  it { should_not allow_value('Other').for(:submittable_type) }

  it { should validate_presence_of :title }

  it { should belong_to(:survey) }
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
    question.steps.should == [2, 3, 4, 5]
  end
end
