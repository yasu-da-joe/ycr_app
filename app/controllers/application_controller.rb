class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :require_login, except: [:new, :create]

  def user_signed_in?
    logged_in?
  end
  helper_method :user_signed_in?

  def after_sign_in_path_for(resource)
    mypage_path
  end

  private

  def not_authenticated
    redirect_to login_path, danger: "ログインしてください"
  end
end
