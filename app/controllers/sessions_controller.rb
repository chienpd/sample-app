class SessionsController < ApplicationController
  def create
    session = params[:session]
    user = User.find_by email: session[:email].downcase
    if user && user.authenticate(session[:password])
      if user.activated?
        login_success user
      else
        activate_require
      end
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def login_success user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end

  def login_fail
    flash[:danger] = t "error.sentence_2"
    render :new
  end

  def activate_require
    message = t "user.acc_act.not_activated"
    flash[:warning] = message
    redirect_to root_url
  end
end
