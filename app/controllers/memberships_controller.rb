class MembershipsController < ApplicationController
  respond_to :html

  before_action :require_login
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  def index
    @memberships = context.memberships
  end

  def show
  end

  def new
    @membership = Membership.new
  end

  def edit
  end

  def create
    @membership = current_user.memberships.create(membership_params)
    respond_with @membership
  end

  def update
    @membership.update(membership_params)
    respond_with @membership
  end

  def destroy
    @membership.destroy
    redirect_to memberships_url
  end

  private

  def context
    if params[:group_id].present?
      @context = current_user.groups.find(params[:group_id])
    end
    @context ||= current_user
  end

  def set_membership
    @membership = Membership.find(params[:id])
    authorize @membership
  end

  def flash_membership
    flash_for @membership
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def membership_params
    params.require(:membership).permit(:group_id)
  end
end
