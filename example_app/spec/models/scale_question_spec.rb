describe ScaleQuestion do
  subject { build_stubbed(:scale_question) }

  it { should validate_presence_of(:maximum) }
  it { should validate_presence_of(:minimum) }
end

describe ScaleQuestion, '#steps' do
  it 'returns all numbers starting at the minimum and ending at the maximum' do
    question = build_stubbed(:scale_question, minimum: 2, maximum: 5)
    question.steps.should eq [2, 3, 4, 5]
  end
end
