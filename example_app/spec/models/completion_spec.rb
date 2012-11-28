require 'spec_helper'

describe Completion, 'associations' do
  it { should belong_to(:survey) }
  it { should belong_to(:user) }
  it { should have_many(:answers) }
end

describe Completion, '#save' do
  it 'should deliver a completion notification' do
    Mailer.stub(completion_notification: stub(deliver: true))
    Mailer.should_receive(:completion_notification).with('Wes', 'Mantooth', 'mantooth13@aol.com')

    user = create(:user, first_name: 'Wes', last_name: 'Mantooth', email: 'manthooth13@aol.com')
    completion = create(:completion, user: user)
  end
end

describe Completion, 'answers_attributes=' do
  it 'builds answers to each of the questions' do
    completion = build_stubbed(:completion)

    completion.answers_attributes = [
      { question_id: 1, text: 'one' },
      { question_id: 2, text: 'two' },
      { question_id: 3, text: 'three' }
    ]

    answer_attributes =
      completion.
      answers.
      map { |answer| answer.attributes.slice('completion_id', 'question_id', 'text') }
    answer_attributes.should == [
      { 'completion_id' => completion.id, 'question_id' => 1, 'text' => 'one' },
      { 'completion_id' => completion.id, 'question_id' => 2, 'text' => 'two' },
      { 'completion_id' => completion.id, 'question_id' => 3, 'text' => 'three' }
    ]
  end
end
