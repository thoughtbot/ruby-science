require 'spec_helper'

describe SurveyInviter, 'Validations' do
  it { should ensure_length_of(:recipients).is_at_least(1) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:sender) }
  it { should validate_presence_of(:survey) }
end

describe SurveyInviter, '#invite' do
  it 'invites a valid recipient' do
    params = valid_params
    SurveyInviter.new(params).invite

    Invitation.count.should eq 1
    ActionMailer::Base.deliveries.last.should have_body_text(params[:message])
  end

  it 'returns false for an invalid recipient' do
    SurveyInviter.new(invalid_params).invite.should be_false
  end

  it "doesn't send emails if any invitations fail to save" do
    invitation = stub('invitation', deliver: true)
    error = StandardError.new('failure')
    Invitation.stubs(:create!).returns(invitation).then.raises(error)
    params = valid_params(recipients: 'one@example.com,two@example.com')
    inviter = SurveyInviter.new(params)

    expect { inviter.invite }.to raise_error(StandardError, 'failure')

    invitation.should have_received(:deliver).never
  end

  def valid_params(overrides = {})
    {
      survey: build(:survey),
      sender: build(:sender),
      message: 'Take my survey!',
      recipients: 'valid@example.com'
    }.merge(overrides)
  end

  def invalid_params
    valid_params.merge(
      recipients: 'invalid_email'
    )
  end
end
