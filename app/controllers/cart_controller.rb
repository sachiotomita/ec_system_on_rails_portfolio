class CartController < ApplicationController
  layout 'store'
  before_action :set_cart

  def show
    if user_signed_in?
      @cart_items = @cart.cart_items.includes(:product)
    else
      @cart_items = @cart.cart_items
    end
  end

  def add_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i || 1

    if product.in_stock?
      @cart.add_product(product, quantity)
      
      # ゲストユーザーの場合はセッションに保存
      unless user_signed_in?
        @cart.save_to_session(session)
        session[:cart_id] = @cart.id if @cart.id
      end
      
      if request.xhr?
        render json: { 
          success: true, 
          message: '商品をカートに追加しました。',
          cart_count: @cart.total_items
        }
      else
        redirect_to cart_path, notice: '商品をカートに追加しました。'
      end
    else
      if request.xhr?
        render json: { 
          success: false, 
          message: 'この商品は在庫切れです。'
        }
      else
        redirect_to product_path(product), alert: 'この商品は在庫切れです。'
      end
    end
  end

  def update_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    @cart.update_quantity(product, quantity)
    
    # ゲストユーザーの場合はセッションに保存
    unless user_signed_in?
      @cart.save_to_session(session)
    end
    
    if request.xhr?
      render json: { 
        success: true, 
        message: 'カートを更新しました。',
        cart_count: @cart.total_items
      }
    else
      redirect_to cart_path, notice: 'カートを更新しました。'
    end
  end

  def remove_item
    product = Product.find(params[:product_id])
    @cart.remove_product(product)
    
    # ゲストユーザーの場合はセッションに保存
    unless user_signed_in?
      @cart.save_to_session(session)
    end
    
    if request.xhr?
      render json: { 
        success: true, 
        message: '商品をカートから削除しました。',
        cart_count: @cart.total_items
      }
    else
      redirect_to cart_path, notice: '商品をカートから削除しました。'
    end
  end

  def clear
    if user_signed_in?
      @cart.cart_items.destroy_all
    else
      @cart.session_items.clear
      @cart.save_to_session(session)
    end
    
    if request.xhr?
      render json: { 
        success: true, 
        message: 'カートを空にしました。',
        cart_count: @cart.total_items
      }
    else
      redirect_to cart_path, notice: 'カートを空にしました。'
    end
  end

  def count
    cart_count = @cart.total_items
    render json: { count: cart_count }
  end

  private

  def set_cart
    if user_signed_in?
      @cart = current_user.cart || current_user.create_cart
    else
      # セッションベースのカート（ゲスト用）
      @cart = Cart.new
      @cart.load_from_session(session[:cart_items] || {})
      # カートIDをセッションに保存
      session[:cart_id] = @cart.id if @cart.id
    end
  end
end
