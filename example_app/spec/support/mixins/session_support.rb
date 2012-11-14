module SessionSupport
  def sign_in
    user = create(:user, password: 'test')
    visit '/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'test'
    click_on 'Sign in'
  end
end

RSpec.configure do |config|
  config.include SessionSupport, type: :feature
end
