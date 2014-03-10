class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  respond_to :html

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
    @group = Group.new(group_params)
    flash[:notice] = 'Group was successfully created.' if @group.save
    respond_with @group
  end

  def update
    if @group.update(group_params)
      flash[:notice] = 'Group was successfully created.'
    end
    respond_with @group
  end

  def destroy
    @group.destroy
      flash[:notice] = "Group #{@group.name} was successfully destroyed."
    respond_with @group
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :visibility, :participation)
    end
end
