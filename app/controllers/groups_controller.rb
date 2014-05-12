class GroupsController < ApplicationController

  respond_to :html
  decorates_assigned :groups, :group

  before_action :require_login, only: [:new, :create]
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  after_action :flash_group, only: [:create, :update, :destroy]

  def index
    @groups = policy_scope(Group)
  end

  def show
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = current_user.groups.create(group_params)
    respond_with @group
  end

  def update
    @group.update group_params
    respond_with @group
  end

  def destroy
    @group.destroy
    redirect_to groups_url
  end

  private

  def set_group
    @group = Group.find(params[:id])
    authorize @group
  end

  def flash_group
    flash_for @group
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name, :visibility, :participation)
  end
end
