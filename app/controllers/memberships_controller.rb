class MembershipsController < ApplicationController

  before_action :target_project
  before_action :authenticate_user
  before_action :project_member_authorization
  before_action :project_owner_authorization, except: [:index]
  before_action :project_must_have_at_least_one_owner, only: [:update, :destroy]

  before_action do
    @project = Project.find(params[:project_id])
  end

  def index
     @membership = @project.memberships.new
   end

  def create
    @membership = @project.memberships.new(membership_params)
    if @membership.save
    flash[:success] = "#{@membership.user.full_name} was successfully added"
    redirect_to project_memberships_path
    else
      render :index
    end
  end

  def edit
    @membership = Membership.find(params[:id])
  end

  def update
    @membership = Membership.find(params[:id])
    if @membership.update(membership_params)
      flash[:success] = "#{@membership.user.full_name} was successfully updated"
      redirect_to project_memberships_path
    else
      render :index
    end
  end

  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
    flash[:success] = "#{@membership.user.full_name} was removed from project"
    redirect_to project_memberships_path
  end

  private

    def membership_params
      params.require(:membership).permit(:role, :project_id, :user_id)
    end

    def target_project
      @project = Project.find(params[:project_id])
    end

    def project_must_have_at_least_one_owner
      if @membership.role == 'Owner' && @project.memberships.where(role: 'Owner').count <= 1
        flash[:warning] = "Projects must have at least one owner"
        redirect_to project_memberships_path(@project)
      end
    end



 end
