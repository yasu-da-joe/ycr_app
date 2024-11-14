class UsersController < ApplicationController
  before_action :require_login, only: [:mypage]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      flash[:success] = "ユーザー登録が成功しました"
      redirect_to mypage_path
    else
      flash.now[:danger] = @user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other
  end

  def mypage
    @user = current_user
  end

  def myreports
    @user = current_user
    @reports = current_user.reports.includes(:concert).order(created_at: :desc)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
