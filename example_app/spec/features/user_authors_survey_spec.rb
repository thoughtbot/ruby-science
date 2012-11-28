feature 'user authors survey' do
  include SurveySupport

  scenario "attempt to edit another user's survey" do
    user = sign_in
    create_survey_with_title 'How are you?'
    click_on 'How are you?'
    page.should have_content("Author: #{user.email}")
  end

  def have_edit_links
    have_css('a', text: /Add .*Question/)
  end
end
