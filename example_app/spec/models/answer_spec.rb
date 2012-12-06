require 'spec_helper'

describe Answer do
  it { should belong_to(:completion) }
  it { should belong_to(:question) }

  it { should validate_presence_of(:text) }
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
end

describe Answer, '.most_recent_answer' do
  it 'returns the latest answer' do
    create(:answer, text: 'middle', created_at: 2.days.ago)
    create(:answer, text: 'newest', created_at: 1.day.ago)
    create(:answer, text: 'oldest', created_at: 3.days.ago)

    result = Answer.most_recent

    result.text.should eq 'newest'
  end
end
