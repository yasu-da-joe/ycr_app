class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # 基本的に全てのアクションでログインを要求
  before_action :authenticate_user!, unless: :skip_auth?
  
  def after_sign_in_path_for(resource)
    mypage_path
  end

  private

  def reports_controller?
    controller_name == 'reports'
  end

  def skip_auth?
    devise_controller? || (reports_controller? && ['index', 'show', 'search'].include?(action_name))
  end

  # Deviseの認証失敗時のリダイレクト先をカスタマイズ
  def authenticate_user!
    if !user_signed_in?
      if reports_controller? && action_name == 'new'
        redirect_to reports_invitation_path, alert: '投稿するにはログインが必要です'
        return false
      end
      super
    end
    respond_to do |format|
      format.html { redirect_to login_path unless current_user }
      format.js   { head :unauthorized unless current_user }
    end
  end
end