class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # ロケール設定
  before_action :set_locale

  # Deviseのヘルパーメソッドをビューで使用可能にする
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Deviseのヘルパーメソッドを明示的に追加
  helper_method :user_signed_in?, :current_user, :user_session

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :address, :city, :state, :postal_code, :country])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :address, :city, :state, :postal_code, :country])
  end

  private

  def set_locale
    I18n.locale = :ja
  end
end
