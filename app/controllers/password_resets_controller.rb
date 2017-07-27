class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if user
      create_password user
    else
      flash.now[:danger] = t "user.acc_reset_pass.mail_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      password_empty
    elsif user.update_attributes user_params
      update_password user
    else
      render :edit
    end
  end

  private

  attr_reader :user

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if user && user.activated? && user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless user.password_reset_expired?
    flash[:danger] = t "user.acc_reset_pass.expiration"
    redirect_to new_password_reset_url
  end

  def password_empty
    user.errors.add :password, t("user.acc_reset_pass.pass_empty")
    render :edit
  end

  def create_password user
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = t "user.acc_reset_pass.mail_sended"
    redirect_to root_url
  end

  def update_password user
    user.update_attributes reset_digest: nil
    log_in user
    flash[:success] = t "user.acc_reset_pass.reset_success"
    redirect_to user
  end
end
