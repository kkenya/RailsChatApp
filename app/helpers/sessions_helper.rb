module SessionsHelper
  def log_in(user)
    callback = session[:callback]
    reset_session
    session[:user_id] = user.id
    session[:callback] = callback
    cookies.permanent.signed[:user_id] = user.id
  end

  def logged_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
