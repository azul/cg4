require 'spec_helper'

describe GroupsController do

  # This should return the minimal set of attributes required to create a valid
  # Group. As you add validations to Group, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { name: "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GroupsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:user) {FactoryGirl.create(:user)}

  describe "GET index" do
    it "assigns all groups as @groups" do
      group = Group.create! valid_attributes.merge({visibility: :visible_to_visitor})
      get :index, {}, valid_session
      assigns(:groups).should eq([group])
    end
  end

  describe "GET show" do
    it "assigns the requested group as @group" do
      group = Group.create! valid_attributes
      get :show, {:id => group.to_param}, valid_session
      assigns(:group).should eq(group)
    end
  end

  describe "GET new" do
    it "requires login" do
      get :new, {}, valid_session
      assigns(:group).should be_nil
      response.should redirect_to(root_path)
    end

    it "assigns a new group as @group" do
      sign_in user
      get :new, {}, valid_session
      assigns(:group).should be_a_new(Group)
    end
  end

  describe "GET edit" do
    it "assigns the requested group as @group" do
      group = Group.create! valid_attributes
      get :edit, {:id => group.to_param}, valid_session
      assigns(:group).should eq(group)
    end
  end

  describe "POST create" do
    describe "with valid params" do

      before do
        sign_in user
      end

      it "creates a new Group" do
        expect {
          post :create, {:group => valid_attributes}
        }.to change(Group, :count).by(1)
      end

      it "assigns a newly created group as @group" do
        post :create, {:group => valid_attributes}
        assigns(:group).should be_a(Group)
        assigns(:group).should be_persisted
      end

      it "redirects to the created group" do
        post :create, {:group => valid_attributes}
        response.should redirect_to(Group.last)
      end
    end

    describe "with invalid params" do

      before do
        sign_in user
      end

      it "assigns a newly created but unsaved group as @group" do
        # Trigger the behavior that occurs when invalid params are submitted
        post :create, {:group => { "name" => "" }}
        assigns(:group).should be_a_new(Group)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        post :create, {:group => { "name" => "" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:group) { user.groups.create! valid_attributes }

      before do
        sign_in user
      end

      it "updates the requested group" do
        # Assuming there are no other groups in the database, this
        # specifies that the Group created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Group.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => group.to_param, :group => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested group as @group" do
        put :update, {:id => group.to_param, :group => valid_attributes}, valid_session
        assigns(:group).should eq(group)
      end

      it "redirects to the group" do
        put :update, {:id => group.to_param, :group => valid_attributes}, valid_session
        response.should redirect_to(group)
      end
    end

    describe "with invalid params" do
      let(:group) { user.groups.create! valid_attributes }

      before do
        sign_in user
      end

      it "assigns the group as @group" do
        # Trigger the behavior that occurs when invalid params are submitted
        put :update, {:id => group.to_param, :group => { "name" => "" }}, valid_session
        assigns(:group).should eq(group)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        put :update, {:id => group.to_param, :group => { "name" => "" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    let(:group) { user.groups.create! valid_attributes }

    it "destroys the requested group" do
      sign_in user
      group  # ensure group exists before expect
      expect {
        delete :destroy, {:id => group.to_param}, valid_session
      }.to change(Group, :count).by(-1)
    end

    it "redirects to the groups list" do
      sign_in user
      delete :destroy, {:id => group.to_param}, valid_session
      response.should redirect_to(groups_url)
    end
  end

end
