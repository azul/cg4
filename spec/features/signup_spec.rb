require 'spec_helper'

describe 'Signup' do
  describe 'works' do
    it "displays signup form" do
      visit '/'
      click_on I18n.t(:sign_up)
    end
  end
end
