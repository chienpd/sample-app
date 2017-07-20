module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def remember user
    user.remember
    cookie = cookies.permanent
    cookie.signed[:user_id] = user.id
    cookie[:remember_token] = user.remember_token
  end

  def current_cookies cookies_id
    user = User.find_by id: cookies_id
    return unless user && user.authenticated?(cookies[:remember_token])
    log_in user
    @current_user = user
  end

  def current_user
    session_id = session[:user_id]
    cookies_id = cookies.signed[:user_id]

    if session_id
      @current_user ||= User.find_by id: session_id
    elsif cookies_id
      current_cookies cookies_id
    end
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end
end
