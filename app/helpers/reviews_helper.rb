module ReviewsHelper
  def load_by_reviews
    rv = current_user.reviews.find {|review| review.book_id == @book.id}
  end
end
