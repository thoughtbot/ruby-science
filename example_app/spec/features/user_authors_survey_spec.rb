require 'spec_helper'

feature 'user authors survey' do
  scenario "attempt to edit another user's survey" do
    sign_in
    create_survey_with_title 'How are you?'
    click_on 'How are you?'
    page.should have_content("Author: #{current_user.email}")
  end

  def have_edit_links
    have_css('a', text: /Add .*Question/)
  end
end
