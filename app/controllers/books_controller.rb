class BooksController < ApplicationController
  before_action :load_book, :build_like, :build_reviews, only: :show
  before_action :load_books_by_category, only: %i(show filter)
  before_action :book_by_like, only: :search_like

  def index
    @books = Book.newest
    @book_news = Book.newest.paginate page: params[:page],
      per_page: Settings.controllers.book.index_page
  end

  def show
    @reviews = @book.reviews.ordered.paginate page: params[:page],
      per_page: Settings.page_review
    @book.rate_points = @book.reviews.average(:rate)
  end

  def filter; end

  def search_like
    @search_like = Book.by_like_book @book_like
  end

  private

  def book_params
    params.require(:book).permit :title, :content, :description, :author,
      :publisher, :rate_points, :number_pages, :category_id, :book_img
  end

  def build_like
    @like = @book.likes.new
  end

  def load_book
    @book = Book.find_by id: params[:id]
    return if @book
    flash[:danger] = t "controller.no_data_book"
    redirect_to books_path
  end

  def load_books_by_category
    @books = Book.by_category(params[:category]).limit Settings.models.limit
  end

  def build_reviews
    @review = @book.reviews.build
  end

  def book_by_like
    @book_like = current_user.likes.pluck(:book_id)
  end
end
