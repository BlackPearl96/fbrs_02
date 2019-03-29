class Admin::StaticPagesController < ApplicationController
  layout "admin"
  before_action :admin_user, onely: :index

  def index; end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
