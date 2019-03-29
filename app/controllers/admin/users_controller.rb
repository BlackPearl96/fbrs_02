class Admin::UsersController < Admin::BaseController
  layout "admin"
  before_action :load_user, only: :destroy
  load_and_authorize_resource

  def index
    @users = User.sort_by_created_at.paginate page: params[:page],
      per_page: Settings.controllers.user.index_page_admin
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controller.user.delete_user"
      redirect_to admin_users_path
    else
      flash[:danger] = t "controller.user.delete_faild"
      redirect_to admin_root_path
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controller.user.find_user_error"
    redirect_to root_path
  end
end
