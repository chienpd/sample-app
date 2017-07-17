class SessionsController < ApplicationController
  def new
  end

  def login_success user
    log_in user
    redirect_to user
  end

  def login_fail
    flash[:danger] = t "error.sentence_2"
    render :new
  end

  def create
    session = params[:session]
    user = User.find_by email: session[:email].downcase
    if user && user.authenticate(session[:password])
      login_success user
    else
      login_fail
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
