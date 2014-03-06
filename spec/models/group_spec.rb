require 'spec_helper'

describe Group do
  describe 'visibility' do
    let(:visitor) { nil }
    let(:user) { FactoryGirl.create :user }
    describe 'to public' do
      let(:group) { FactoryGirl.create :public_group }
      it 'is visible to visitors' do
        group.should be_visible_to visitor
      end
      it 'is visible to users' do
        debugger
        group.should be_visible_to user
      end
    end
  end
end
