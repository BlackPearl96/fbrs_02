class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_search_book, :configure_permitted_parameters, if: :devise_controller?
  include SessionsHelper
  include BooksHelper

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up do |user_params|
      user_params.permit :name, :phone, :address,
       :email, :password, :password_confirmation, :role
    end
    devise_parameter_sanitizer.permit :account_update do |user_params|
      user_params.permit :name, :phone, :address,
       :email, :password, :password_confirmation, :role
    end
  end

  def require_log_in
    unless user_signed_in?
      flash[:danger] = t ".pls_login"
      redirect_to new_user_session_path
    end
  end

  def set_search_book
    @q = Book.ransack params[:q]
    @books = @q.result.includes(:category, :likes, :reviews).newest
  end
end
