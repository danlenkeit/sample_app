class SessionsController < ApplicationController
  def new
  end

  def create
  	@user = User.find_by(email: params[:session][:email].downcase)

  	if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
  		# Log the user in and redirect to the user's show page
  		  log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
  		  redirect_back_or @user
      else
        message = "ACCOUNT NOT ACTIVATED, CHECK EMAIL FOR ACTIVATION LINK"
        flash[:warning] = message
        redirect_to login_url
      end
  	else
  		#create error message
  		flash.now[:danger] = 'CHECK YA SHIT FOOL'
  		render 'new'
  	end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
