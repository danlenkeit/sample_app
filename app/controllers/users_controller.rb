class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params) #Not final implementation
  	if @user.save
      @user.send_activation_email
      flash[:info] = "CHECK EMAIL TO ACTIVATE"
      redirect_to root_url
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "DELETED"
    redirect_to users_url
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
        store_location
        flash[:danger] = "GOTTA LOG IN TO DO THAT"
        redirect_to login_url
      end
    end

    #confirms a correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    #confirms admin
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
