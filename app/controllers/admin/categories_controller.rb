class Admin::CategoriesController < Admin::BaseController
  layout "admin"
  before_action :find_category, only: %i(destroy update)
  load_and_authorize_resource


  def index
    @categories = Category.sort_by_name.with_deleted.paginate page: params[:page],
     per_page: Settings.per_page
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def update
    @category = Category.restore(params[:id], recursive: true)
    if @category
      flash[:success] = "undelete success"
      redirect_to admin_categories_path
    else
      flash[:danger] = "cannot undelete"
      redirect_to admin_categories_path
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "deleted"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "un_delete"
      redirect_to admin_root_path
    end
  end

  private

  def category_params
    params.require(:category).permit :name, :parent_id
  end

  def find_category
    @category = Category.find_by_id params[:id]
    return if @category
    flash[:danger] = t "fail"
    redirect_to admin_root_path
  end
end
