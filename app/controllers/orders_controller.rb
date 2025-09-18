class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :show]
  layout 'store'
  before_action :set_order, only: [:show, :cancel]
  before_action :set_cart, only: [:new, :create]

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
    redirect_to cart_path, alert: 'カートが空です。' if @cart.empty?
    @order = Order.new
  end

  def create
    redirect_to cart_path, alert: 'カートが空です。' and return if @cart.empty?

    @order = Order.new(order_params)
    @order.subtotal = @cart.total_price
    @order.tax_amount = calculate_tax(@cart.total_price)
    @order.shipping_amount = calculate_shipping(@cart.total_price)
    @order.payment_method = 'credit_card'
    @order.status = 'pending'
    
    # ログインユーザーの場合はuser_idを設定
    @order.user = current_user if user_signed_in?

    if @order.save
      @order.add_items_from_cart(@cart)
      
      # ログインユーザーの場合はポイントを付与
      if user_signed_in?
        points = (@cart.total_price * 0.01).round
        current_user.add_points(points, "注文によるポイント獲得 (注文番号: #{@order.order_number})")
      end
      
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
    if user_signed_in?
      @order = current_user.orders.find(params[:id])
    else
      # ゲストユーザーの場合はセッションから注文IDを取得
      @order = Order.find(params[:id])
    end
  end

  def set_cart
    if user_signed_in?
      @cart = current_user.cart
    else
      # ゲストユーザーの場合はセッションからカートを取得
      @cart = Cart.new
      @cart.load_from_session(session[:cart_items] || {})
      redirect_to cart_path, alert: 'カートが空です。' if @cart.empty?
    end
  end

  def calculate_tax(subtotal)
    # 簡易的な消費税計算（10%）
    (subtotal * 0.1).round(2)
  end

  def calculate_shipping(subtotal)
    # 簡易的な送料計算（5000円以上で送料無料）
    subtotal >= 5000 ? 0 : 500
  end

  def order_params
    params.require(:order).permit(:shipping_address, :billing_address, :guest_name, :guest_email, :guest_phone)
  end
end
