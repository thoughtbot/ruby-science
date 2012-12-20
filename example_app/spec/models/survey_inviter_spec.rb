require 'spec_helper'

describe SurveyInviter, 'Validations' do
  it { should ensure_length_of(:recipients).is_at_least(1) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:sender) }
  it { should validate_presence_of(:survey) }
end

describe SurveyInviter, '#invite' do
  it 'invites a valid recipient' do
    SurveyInviter.new(valid_params).invite

    Invitation.count.should eq 1
    ActionMailer::Base.deliveries.count.should eq 1
  end

  it 'returns false for an invalid recipient' do
    SurveyInviter.new(invalid_params).invite.should be_false
  end

  def valid_params
    {
      survey: build(:survey),
      sender: build(:sender),
      message: 'Take my survey!',
      recipients: 'valid@example.com'
    }
  end

  def invalid_params
    valid_params.merge(
      recipients: 'invalid_email'
    )
  end
end
