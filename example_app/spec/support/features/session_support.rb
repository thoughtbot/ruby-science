module Features
  def sign_in
    @current_user = create(:user, password: 'test')
    visit '/sign_in'
    fill_in 'Email', with: @current_user.email
    fill_in 'Password', with: 'test'
    click_on 'Sign in'
  end

  def current_user
    @current_user
  end

  def as_another_user
    using_session 'other user' do
      sign_in
      yield
    end
  end
end
