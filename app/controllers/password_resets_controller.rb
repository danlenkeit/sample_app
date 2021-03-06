class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only [:edit, :update]

  def new
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
  	if @user
  		@user.create_reset_digest
  		@user.send_password_reset_email
  		flash[:info] = "PASSWORD RESET EMAIL SENT"
  		redirect_to root_url
  	else
  		flash.now[:danger] = "USER NOT FOUND"
  		render 'new '
  	end
  end

  def edit
  end

  def update
    if password.blank?
      flash.now[:danger] = "PASSWORD CAN'T BE BLANK"
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "PASSWORD RESET"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      password.require(:user).permit(:password, :password_confirmation))
    end

    #returns true if password is blank
    def password_blank?
      params[:user][:password].blank?
    end

    #before filters
    def get_user
      @user = User.find_by(email: params[:email])
    end

    #confirms a user is valid
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    #checks if password link is expired
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "LINK EXPIRED"
        redirect_to new_password_reset_url
      end
    end
end
