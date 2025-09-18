class ProductsController < ApplicationController
  layout 'store'
  before_action :set_product, only: [:show]
  before_action :set_categories

  def index
    @products = Product.includes(:category, :product_images)
                      .active
                      .limit(12)
    
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:search].present?
      @products = @products.where("name LIKE ? OR description LIKE ?", 
                                 "%#{params[:search]}%", "%#{params[:search]}%")
    end

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

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_categories
    @categories = Category.active
  end
end
