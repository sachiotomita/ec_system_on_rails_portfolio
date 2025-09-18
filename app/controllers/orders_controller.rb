class OrdersController < ApplicationController
  before_action :authenticate_user!
  layout 'store'
  before_action :set_order, only: [:show, :cancel]

  def index
    @orders = current_user.orders.includes(:order_items, :products)
                         .order(created_at: :desc)
                         .page(params[:page])
                         .per(10)
  end

  def show
    @order_items = @order.order_items.includes(:product)
  end

  def new
    @cart = current_user.cart
    redirect_to cart_path, alert: 'カートが空です。' if @cart.empty?
  end

  def create
    @cart = current_user.cart
    redirect_to cart_path, alert: 'カートが空です。' and return if @cart.empty?

    @order = current_user.orders.build(
      subtotal: @cart.total_price,
      tax_amount: calculate_tax(@cart.total_price),
      shipping_amount: calculate_shipping(@cart.total_price),
      shipping_address: current_user.address,
      billing_address: current_user.address,
      payment_method: 'credit_card',
      status: 'pending'
    )

    if @order.save
      @order.add_items_from_cart(@cart)
      @cart.cart_items.destroy_all
      redirect_to order_path(@order), notice: '注文が正常に作成されました。'
    else
      render :new
    end
  end

  def cancel
    if @order.can_cancel?
      @order.update(status: 'cancelled')
      redirect_to order_path(@order), notice: '注文をキャンセルしました。'
    else
      redirect_to order_path(@order), alert: 'この注文はキャンセルできません。'
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def calculate_tax(subtotal)
    # 簡易的な消費税計算（10%）
    (subtotal * 0.1).round(2)
  end

  def calculate_shipping(subtotal)
    # 簡易的な送料計算（5000円以上で送料無料）
    subtotal >= 5000 ? 0 : 500
  end
end
