require 'spec_helper'

describe Completion, 'associations' do
  it { should belong_to(:survey) }
  it { should belong_to(:user) }
  it { should have_many(:answers) }
end

describe Completion, '#save' do
  it 'should deliver a completion notification' do
    Mailer.stubs(completion_notification: stub(deliver_now: true))
    user = create(:user)
    completion = create(:completion, user: user)

    Mailer.should have_received(:completion_notification).with(user)
  end
end

describe Completion, 'answers_attributes=' do
  it 'builds answers to each of the questions' do
    completion = build_stubbed(:completion)

    completion.answers_attributes = {
      1 => { text: 'one' },
      2 => { text: 'two' },
      3 => { text: 'three' }
    }

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
