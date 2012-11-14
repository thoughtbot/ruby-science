module FormSupport
  def have_form_error
    have_selector('.error')
  end
end

RSpec.configure do |config|
  config.include FormSupport, type: :feature
end
