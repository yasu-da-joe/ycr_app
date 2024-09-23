class UserSessionsController < ApplicationController
    def new
    end
  
    def create
      @user = login(params[:email], params[:password])
      if @user
        redirect_back_or_to mypage_path, success: 'ログインしました'
      else
        flash[:danger] = 'ログインに失敗しました'
        redirect_to login_path
      end
    end
  
    def destroy
        logout
        redirect_to login_path, success: 'ログアウトしました'
    end
  end