class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

	def create
		@user = User.new(user_params)

		if @user.save then
			flash[:success] = "Welcome buddy :)"
			redirect_to @user
		else
			render 'new'
		end
	end

	private
	def user_params
		params[:user].permit(:name, :email, :password, :password_confirmation)
	end

end
