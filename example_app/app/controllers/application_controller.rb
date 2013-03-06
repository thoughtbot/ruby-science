class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery
  before_filter :require_login
  helper_method :messages_for_current_user

  private

  def messages_for_current_user
    if signed_in?
      current_user.received_messages
    else
      []
    end
  end
end
