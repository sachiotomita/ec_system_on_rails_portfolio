class Store::HomeController < ApplicationController
  layout 'store'
  def index
    @featured_products = Product.includes(:category, :product_images)
                               .active
                               .featured
                               .limit(8)
    
    @categories = Category.active.limit(6)
    @recent_products = Product.includes(:category, :product_images)
                             .active
                             .order(created_at: :desc)
                             .limit(6)
  end
end
