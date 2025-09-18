class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :ensure_can_review, only: [:new, :create]
  before_action :ensure_can_edit, only: [:edit, :update, :destroy]

  def index
    @reviews = @product.reviews.includes(:user).recent.page(params[:page]).per(10)
  end

  def new
    @review = @product.reviews.build
  end

  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: 'レビューを投稿しました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to @product, notice: 'レビューを更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to @product, notice: 'レビューを削除しました。'
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_review
    @review = @product.reviews.find(params[:id])
  end

  def ensure_can_review
    unless @product.can_be_reviewed_by?(current_user)
      redirect_to @product, alert: 'この商品のレビューを投稿するには、商品を購入する必要があります。'
    end
  end

  def ensure_can_edit
    unless @review.can_be_edited_by?(current_user)
      redirect_to @product, alert: 'このレビューを編集する権限がありません。'
    end
  end

  def review_params
    params.require(:review).permit(:rating, :title, :content)
  end
end
