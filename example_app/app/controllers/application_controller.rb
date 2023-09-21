class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery
  before_action :require_login
end
