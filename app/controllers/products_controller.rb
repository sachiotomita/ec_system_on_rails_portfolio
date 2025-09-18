class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit, :create, :update]

  def index
    @products = Product.includes(:category, :product_images)
                      .active
                      .page(params[:page])
                      .per(12)
    
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:search].present?
      @products = @products.where("name ILIKE ? OR description ILIKE ?", 
                                 "%#{params[:search]}%", "%#{params[:search]}%")
    end

    @categories = Category.active
    
    # ホームページ用のフィーチャー商品
    if request.path == root_path
      @featured_products = Product.includes(:category, :product_images)
                                 .active
                                 .featured
                                 .limit(4)
    end
  end

  def show
    @related_products = Product.active
                              .where(category: @product.category)
                              .where.not(id: @product.id)
                              .limit(4)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: '商品が正常に作成されました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: '商品が正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: '商品が正常に削除されました。'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_categories
    @categories = Category.active
  end

  def product_params
    params.require(:product).permit(:name, :description, :short_description, :price, :sale_price, 
                                   :sku, :stock_quantity, :active, :featured, :category_id)
  end
end
