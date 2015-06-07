class SessionsController < ApplicationController
	class SessionModel
		attr_accessor :email
	end

	attr_accessor :current_session
	delegate :email, to: :current_session, allow_nil: true
	helper_method :email

	def new
		if signed_in? then
			redirect_to current_user
		end
	end

	def create
		user = User.find_by(email:params[:session][:email].downcase)
		if user&& user.authenticate(params[:session][:password]) then
			sign_in user
			redirect_to user
		else
			flash.now[:error] = "Wrong name or password"
			self.current_session = SessionModel.new
			self.current_session.email = params[:session][:email]
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end

end
