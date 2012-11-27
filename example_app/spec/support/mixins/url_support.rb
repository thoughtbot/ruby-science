module UrlSupport
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes_url_helpers
  end
end

RSpec.configure do |config|
  config.include UrlSupport, type: :feature
end
