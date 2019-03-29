class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :load_user, only: :show
  before_action :load_follow, :load_unfollow, only: %i(following followers show)

  def index
    @users = User.sort_by_name.paginate page: params[:page],
      per_page: Settings.controllers.user.index_page
  end

  def show; end

  # def update_role
  #   if @user.admin?
  #     @user.user!
  #     flash[:success] = t "controller.user.setuser"
  #     redirect_to request.referrer
  #   elsif @user.user?
  #     @user.admin!
  #     flash[:success] = t "controller.user.setadmin"
  #     redirect_to request.referrer
  #   else
  #     flash[:danger] = t "controller.user.nofound"
  #     redirect_to request.referrer
  #   end
  # end

  def destroy
    if @user.destroy
      flash[:success] = t "controller.user.delete_user"
      redirect_to users_path
    else
      flash[:danger] = t "controller.user.delete_faild"
      redirect_to root_path
    end
  end

  def following
    @title = t "controller.user.following"
    @users = @user.following.paginate page: params[:page],
      per_page: Settings.per_page
    render :show_follow
  end

  def followers
    @title = t "controller.user.followers"
    @users = @user.followers.paginate page: params[:page],
      per_page: Settings.per_page
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :phone,
      :address, :password, :password_confirmation, :role
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controller.user.find_user_error"
    redirect_to root_path
  end

  def load_follow
    @follow = current_user.active_relationships.build
  end

  def load_unfollow
    @unfollow = current_user.active_relationships.find_by(followed_id: @user.id)
  end
end
