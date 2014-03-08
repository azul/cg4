require 'spec_helper'

describe Group do
  describe 'visible' do
    let(:visitor) { nil }
    let(:user) { FactoryGirl.create :user }
    describe 'to visitors' do
      let(:group) { FactoryGirl.create :public_group }
      it 'is visible to visitor' do
        group.should be_visible_to visitor
        Group.visible_to(visitor).should include group
      end
      it 'is visible to user' do
        group.should be_visible_to user
        Group.visible_to(user).should include group
      end
    end
  end
end
