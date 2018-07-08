module SessionsHelper
  def log_in(user)
    callback = session[:callback]
    reset_session
    session[:user_id] = user.id
    session[:callback] = callback
  end
end
