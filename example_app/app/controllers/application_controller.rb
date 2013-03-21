class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery
  before_filter :require_login
end
