class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.page(params[:page]).per(20).order(:name)
  end

  def show
    @products = @category.products.includes(:product_images)
                        .page(params[:page])
                        .per(20)
                        .order(created_at: :desc)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_category_path(@category), notice: 'カテゴリが正常に作成されました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_category_path(@category), notice: 'カテゴリが正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    if @category.products.any?
      redirect_to admin_categories_path, alert: 'このカテゴリには商品が含まれているため削除できません。'
    else
      @category.destroy
      redirect_to admin_categories_path, notice: 'カテゴリが正常に削除されました。'
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :active)
  end

end
