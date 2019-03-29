class LikesController < ApplicationController
  before_action :load_book, only: [:create, :destroy]
  before_action :load_unlike, only: :destroy
  load_and_authorize_resource
  def create
    unless check_like?
      @like = current_user.likes.create(book_id: @book.id)
      # target_activity @like
      respond_to do |format|
        format.html{ redirect_to request.referrer }
        format.js
      end
    end
  end

  def destroy
    if check_like? && @unlike.destroy
      # target_activity @unlike
      respond_to do |format|
        format.html{redirect_to request.referrer}
        format.js
      end
    else
      flash[:danger] = t "controller.likes.unlike_fail"
      redirect_to request.referrer
    end
  end

  private

  def check_like?
    Like.by_like_user(current_user.id, params[:book_id]).exists?
  end

  def load_book
    @book = Book.find_by id: params[:book_id]
    return if @book
    flash[:danger] = t "controller.likes.load_like"
    redirect_to root_path
  end

  def load_unlike
    @unlike = current_user.likes.find_by(book_id: @book.id)
    return if @book
    flash[:danger] = t "controller.likes.un_like"
    redirect_to book_path(@book)
  end
end
