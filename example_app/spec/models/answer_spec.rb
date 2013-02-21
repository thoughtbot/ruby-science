require 'spec_helper'

describe Answer do
  it { should belong_to(:completion) }
  it { should belong_to(:question) }
end

describe Answer, '.for_user' do
  it 'returns the answer for the given user' do
    user = create(:user)
    other_user = create(:user)
    user_completion = create(:completion, user: user)
    other_completion = create(:completion, user: other_user)
    create(:answer, completion: user_completion, text: 'expected')
    create(:answer, completion: other_completion, text: 'other user')

    result = Answer.for_user(user)

    result.text.should eq 'expected'
  end

  it 'returns a null answer when missing' do
    user = create(:user)

    result = Answer.for_user(user)

    result.should be_a(NullAnswer)
  end
end

describe Answer, '.most_recent_answer' do
  it 'returns the latest answer' do
    create(:answer, text: 'middle', created_at: 2.days.ago)
    create(:answer, text: 'newest', created_at: 1.day.ago)
    create(:answer, text: 'oldest', created_at: 3.days.ago)

    result = Answer.most_recent

    result.text.should eq 'newest'
  end

  it 'returns a null answer when missing' do
    result = Answer.most_recent

    result.should be_a(NullAnswer)
  end
end

describe Answer, '#score' do
  it 'asks its question to score its text' do
    question = build_stubbed(:question)
    question.stubs(score: 10)
    answer = build_stubbed(:answer, question: question, text: 'the text')

    result = answer.score

    question.should have_received(:score).with('the text')
    result.should eq 10
  end
end
