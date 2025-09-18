class Admin::DashboardController < Admin::BaseController

  def index
    @total_products = Product.count
    @total_orders = Order.count
    @total_users = User.count
    @recent_orders = Order.includes(:user, :order_items)
                         .order(created_at: :desc)
                         .limit(10)
    @low_stock_products = Product.where('stock_quantity < ?', 10)
                                .limit(5)
    
    # 売上統計（過去30日）
    @recent_sales = Order.where(created_at: 30.days.ago..Time.current)
                        .where(status: ['processing', 'shipped', 'delivered'])
                        .sum(:total_amount)
    
    # 月別売上データ（過去6ヶ月）
    @monthly_sales = Order.where(created_at: 6.months.ago..Time.current)
                         .where(status: ['processing', 'shipped', 'delivered'])
                         .group_by_month(:created_at)
                         .sum(:total_amount)
  end

end
