class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      acc_activated user
    else
      flash[:danger] = t "user.acc_act.invalid_link"
      redirect_to root_url
    end
  end

  def acc_activated user
    user.activate
    log_in user
    flash[:success] = t "user.acc_act.activated"
    redirect_to user
  end
end
