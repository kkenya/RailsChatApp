class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user&.authenticate(params[:session][:password])
      log_in user
      # return redirect_to session[:callback] if session[:callback].present?
      redirect_to user
    else
      flash.now[:danger] = '無効なメールアドレス/ユーザー名の組み合わせです'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_url
  end
end
