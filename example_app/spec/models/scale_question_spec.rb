describe ScaleQuestion do
  subject { build_stubbed(:scale_question) }

  it { should validate_presence_of(:maximum) }
  it { should validate_presence_of(:minimum) }
end
