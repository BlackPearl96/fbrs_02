class SuggestsController < ApplicationController
  before_action :logged_in_user
  before_action :load_suggest, only: :destroy
  before_action :suggest_by_user, only: :index
  load_and_authorize_resource

  def index; end

  def new
    @suggest = current_user.suggests.build
  end

  def create
    @suggest = Suggest.new suggest_params
    if @suggest.save
      flash[:success] = t "controller.success_rq"
      redirect_to suggests_path(user_id: current_user)
    else
      flash.now[:danger] = t "can't_rq"
      render :new
    end
  end

  def destroy
    if @suggest.destroy
      flash[:success] = t "deleted"
      redirect_to suggests_path(user_id: current_user)
    else
      flash[:danger] = t "un_delete"
      redirect_to root_path
    end
  end

  private

  def suggest_params
    params.require(:suggest).permit :user_id, :title,
     :content, :author, :categories
  end

  def load_suggest
    @suggest = Suggest.find_by id: params[:id]
    return if @suggest
    flash[:danger] = t "controller.no_data_rq"
    redirect_to root_path
  end

  def suggest_by_user
    @suggests = current_user.suggests.newest.by_suggest params[:user_id]
  end

  def logged_in_user
    return if user_signed_in?
    store_location
    flash[:danger] = t ".pls_login"
    redirect_to new_user_session_path
  end
end
