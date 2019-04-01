class Admin::UsersController < Admin::BaseController
  layout "admin"
  before_action :load_user, only: %i(destroy update)
  load_and_authorize_resource

  def index
    @users = User.sort_by_created_at.paginate page: params[:page],
      per_page: Settings.controllers.user.index_page_admin
    respond_to do |format|
      format.html
      format.csv{send_data @users.to_csv, filename: "users-#{Date.today}.csv"}
      format.xls{send_data @users.to_csv(col_sep: "\t"),
        filename: "users-#{Date.today}.csv"}
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = "add success"
      redirect_to admin_users_path
    else
      flash[:danger] = "cannot add user"
      render :new
    end
  end

  def update
    @user.role = params[:value]
    if @user.save
      respond_to do |format|
        format.html{ redirect_to request.referrer }
        format.js
      end
    else
      flash[:danger] = t "controller.user.nofound"
      redirect_to request.referrer
    end
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

  def user_params
    params.require(:user).permit :name, :phone, :address,
      :email, :password, :password_confirmation, :role
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controller.user.find_user_error"
    redirect_to root_path
  end
end
