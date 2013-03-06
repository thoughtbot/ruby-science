class InvitationMessage < AbstractController::Base
  include AbstractController::Rendering
  include Rails.application.routes.url_helpers

  self.view_paths = 'app/views'
  self.default_url_options = ActionMailer::Base.default_url_options

  def initialize(invitation)
    @invitation = invitation
  end

  def body
    render template: 'invitations/message'
  end
end
