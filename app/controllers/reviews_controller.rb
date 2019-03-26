class ReviewsController < ApplicationController
  before_action :logged_in_user, only: %i(new create destroy)
  before_action :load_book, only: %i(create destroy)
  before_action :load_review, only: :destroy

  def new; end

  def create
    @review = @book.reviews.new(review_params)
    @review.user_id = current_user.id
    if @review.save
        respond_to do |format|
        format.html { redirect_to book_review_path(review.book, review) }
        format.js
      end
    else
      render :new
    end
  end

  def destroy
    if @review.destroy
      respond_to do |format|
        format.html { redirect_to request.referrer }
        format.js { }
      end
    else
      flash[:danger] = t "controller.reviews.delete_review_fail"
      redirect_to root_path
    end
  end

  private

  def review_params
    params.require(:review).permit :rate, :content
  end

  def load_book
    @book = Book.find_by id: params[:book_id]
    return if @book
    flash[:danger] = t "controller.no_data_book"
    redirect_to root_path
  end

  def load_review
    @review = Review.find_by id: params[:id]
    return if @review
    flash[:danger] = t "controller.no_data_review"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "please_login"
    redirect_to login_path
  end
end
