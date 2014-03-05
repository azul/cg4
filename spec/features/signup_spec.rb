require 'spec_helper'

describe 'Signup' do
    it "displays signup form" do
      visit '/'
      click_on I18n.t(:sign_up)
      page.should have_content(I18n.t("sign_up"))
    end

    it 'reports missing fields' do
      visit '/'
      click_on I18n.t(:sign_up)
      click_button I18n.t(:sign_up)
      error_message = I18n.t "errors.messages.not_saved",
        resource: 'user',
        count: 2
      expect(page).to have_content(error_message)
    end
end
