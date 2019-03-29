class Admin::BaseController < ApplicationController
  before_action :require_log_in, :check_admin_permission

  def check_admin_permission
    unless current_user.admin?
      flash[:danger] = t "denied"
      redirect_to root_path
    end
  end
end
