class Admin::SuggestsController < Admin::BaseController
  layout "admin"
  before_action :load_suggest, :build_book, only: %i(update edit)

  def index
    @suggests = Suggest.newest.paginate page: params[:page],
     per_page: Settings.per_page
  end

  def edit; end

  def update
    @suggest.status = params[:value]
    if @suggest.save
      flash[:warning] =  t ".book_status", name: @suggest.title,
        value: @suggest.status
    else
      flash[:danger] = "faild"
    end
    redirect_to admin_suggests_path
  end

  private

  def load_suggest
    @suggest = Suggest.find_by id: params[:id]
    return if @suggest
    flash[:danger] = t "controller.no_data_rq"
    redirect_to root_path
  end

  def build_book
    @book = Book.new
  end
end
