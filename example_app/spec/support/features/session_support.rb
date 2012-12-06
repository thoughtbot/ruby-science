module Features
  def sign_in
    sign_in_as create(:user)
  end

  def sign_in_as(user)
    @current_user = user
    visit '/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'
  end

  def current_user
    @current_user
  end

  def as_another_user
    other_user = create(:user)
    using_session other_user.email do
      sign_in_as other_user
      yield
    end
  end
end
