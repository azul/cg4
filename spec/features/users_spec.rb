require 'spec_helper'

describe 'Users' do
  describe 'listed in the directory' do
    it "displays public users" do
      user = FactoryGirl.create :user
      visit '/users'
      page.should have_content(user.display_name)
    end
  end
end
