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
