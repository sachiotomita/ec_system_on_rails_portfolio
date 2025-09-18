class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  layout 'admin'

  private

  def authenticate_admin!
    redirect_to store_root_path, alert: '管理者権限が必要です。' unless current_user&.admin?
  end
end
