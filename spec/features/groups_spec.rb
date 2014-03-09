require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'Groups' do
  describe 'the directory' do
    it 'can be reached from the landing page' do
      visit '/'
      click_on I18n.t("groups.nav")
      page.should have_content(I18n.t("groups.index.directory"))
    end

    it 'displays public groups' do
      group = FactoryGirl.create :public_group
      visit '/groups'
      page.should have_content(group.display_name)
    end

    it 'hides groups from public by default' do
      group = FactoryGirl.create :group
      visit '/groups'
      page.should_not have_content(group.display_name)
    end

    it 'hides hidden groups from non members' do
      user = FactoryGirl.create :user
      group = FactoryGirl.create :hidden_group
      login_as user, scope: :user
      visit '/groups'
      page.should_not have_content(group.display_name)
    end
  end

  describe 'creation' do
    it 'can be reached from the landing page' do
      visit '/'
      click_on I18n.t("groups.nav")
      click_on I18n.t("groups.index.new")
      fill_in 'Name', with: 'Test Group'
      click_button 'Create group'
      Group.last.name.should eq('Test Group')
    end
  end

  after { Warden.test_reset! }

end



