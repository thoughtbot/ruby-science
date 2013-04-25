class InvitationDeliverer
  include FactoryGirl::Syntax::Methods

  def initialize(factory)
    @factory = factory
  end

  def deliver_invitation(overrides = {})
    attributes = {
      message: 'hello',
      survey: create(:survey)
    }.merge(overrides)
    invitation_attributes = create(:invitation, attributes).attributes

    @factory.new(invitation_attributes).tap do |invitation|
      invitation.deliver
    end
  end
end
