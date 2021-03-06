require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "changeme",
      :password_confirmation => "changeme"
    }
  end

  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end

  describe "visible" do

    let(:other_user) { FactoryGirl.build :user }
    let(:visitor) { nil }
    let(:friend) {
      FactoryGirl.build(:user).tap do |u|
        user.friend_ids = [u.id]
      end
    }
    let(:peer) {
      FactoryGirl.build(:user).tap do |u|
        user.peer_ids = [u.id]
      end
    }

    describe "to visitors" do
      let (:user) { FactoryGirl.create :public_user }
      it "is visible to visitor" do
        user.should be_visible_to visitor
      end

      it "is visible to user" do
        user.should be_visible_to user
      end
    end

    describe "to users" do
      let (:user) { FactoryGirl.create :user }
      it "is hidden from visitor" do
        user.should_not be_visible_to visitor
      end

      it "is visible to user" do
        user.should be_visible_to user
      end
    end

    describe "to peers" do
      let (:user) { FactoryGirl.create :user, visibility: :visible_to_peer }
      it "is hidden from user" do
        user.should_not be_visible_to other_user
      end

      it "is visible to peer" do
        user.should be_visible_to peer
      end

      it "is visible to friend" do
        user.should be_visible_to friend
      end
    end

    describe "to self" do
      let (:user) { FactoryGirl.create :hidden_user}
      it "is hidden from friends" do
        user.should_not be_visible_to friend
      end

      it "is visible to self" do
        user.should be_visible_to user
      end
    end

  end

end
