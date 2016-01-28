module SessionsHelper

	#Log a fool in
	def log_in(user)
		session[:user_id] = user.id
	end

	#returns currently logged in fool
	def current_user
		@current_user ||= User.find_by(:id, session[:user_id])
	end
end
