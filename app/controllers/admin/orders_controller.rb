class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :update]

  def index
    @orders = Order.includes(:user, :order_items)
                  .page(params[:page])
                  .per(20)
                  .order(created_at: :desc)
    
    if params[:status].present?
      @orders = @orders.where(status: params[:status])
    end

    if params[:search].present?
      @orders = @orders.joins(:user)
                      .where("orders.order_number ILIKE ? OR users.first_name ILIKE ? OR users.last_name ILIKE ?", 
                             "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
  end

  def show
    @order_items = @order.order_items.includes(:product)
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: '注文が正常に更新されました。'
    else
      render :show
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :payment_status, :shipped_at, :delivered_at)
  end

end
