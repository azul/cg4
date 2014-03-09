require 'spec_helper'

describe 'Login' do
  let(:user) { FactoryGirl.create :user }
  it 'logs in successfully' do
    visit '/'
    click_on I18n.t(:login)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button I18n.t(:login)
    page.should have_content(I18n.t("devise.sessions.signed_in"))
    page.should_not have_content(I18n.t(:login))
    page.should have_content(I18n.t(:logout))
  end
end
