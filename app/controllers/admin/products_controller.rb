class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit, :create, :update]

  def index
    @products = Product.includes(:category, :product_images)
                      .page(params[:page])
                      .per(20)
                      .order(created_at: :desc)
    
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:search].present?
      @products = @products.where("name ILIKE ? OR description ILIKE ?", 
                                 "%#{params[:search]}%", "%#{params[:search]}%")
    end

    if params[:status].present?
      case params[:status]
      when 'active'
        @products = @products.where(active: true)
      when 'inactive'
        @products = @products.where(active: false)
      when 'low_stock'
        @products = @products.where('stock_quantity < ?', 10)
      end
    end

    @categories = Category.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_product_path(@product), notice: '商品が正常に作成されました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: '商品が正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: '商品が正常に削除されました。'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_categories
    @categories = Category.all
  end

  def product_params
    params.require(:product).permit(:name, :description, :short_description, :price, :sale_price, 
                                   :sku, :stock_quantity, :active, :featured, :category_id)
  end

end
