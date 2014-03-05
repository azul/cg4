require 'spec_helper'

describe 'Signup' do
    it "displays signup form" do
      visit '/'
      click_on I18n.t(:sign_up)
      page.should have_content(I18n.t("sign_up"))
    end

    it "signs up successfully" do
      user = FactoryGirl.build :user
      visit '/users/sign_up'
      fill_in 'Name', with: user.name
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with:user.password
      click_button I18n.t(:sign_up)
      page.should have_content(I18n.t("devise.registrations.signed_up"))
      user_record = User.find_by_email(user.email)
      user_record.name.should eq(user.name)
    end

    it 'reports missing fields' do
      visit '/users/sign_up'
      click_button I18n.t(:sign_up)
      error_message = I18n.t "errors.messages.not_saved",
        resource: 'user',
        count: 2
      expect(page).to have_content(error_message)
    end
end
