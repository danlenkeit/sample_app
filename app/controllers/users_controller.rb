class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params) #Not final implementation
  	if @user.save
      log_in @user
      flash[:success] = "YO YO YO CHECK IT OUT!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #handle a successful update
      flash[:success] = "UPDATED"
      redirect_to @user
    else
      render 'edit'
    end
  end


  ####
  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    #before filters

    #confirms a logged in user
    def logged_in_user
      unless logged_in?
        flash[:danger] = "GOTTA LOG IN TO DO THAT"
        redirect_to login_url
      end
    end
end
