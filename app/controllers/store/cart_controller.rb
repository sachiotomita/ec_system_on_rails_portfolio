class Store::CartController < Store::BaseController
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:product)
  end

  def add_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i || 1

    if product.in_stock?
      @cart.add_product(product, quantity)
      redirect_to store_cart_path, notice: '商品をカートに追加しました。'
    else
      redirect_to store_product_path(product), alert: 'この商品は在庫切れです。'
    end
  end

  def update_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    @cart.update_quantity(product, quantity)
    redirect_to store_cart_path, notice: 'カートを更新しました。'
  end

  def remove_item
    product = Product.find(params[:product_id])
    @cart.remove_product(product)
    redirect_to store_cart_path, notice: '商品をカートから削除しました。'
  end

  def clear
    @cart.cart_items.destroy_all
    redirect_to store_cart_path, notice: 'カートを空にしました。'
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end
end
