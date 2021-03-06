class UsersController < ApplicationController
	before_action :signed_in_user, only: [:index,:edit,:update, :destroy]
	before_action :correct_user, only: [:edit,:update]
	before_action :admin_user, only: [:destroy]
	before_action :unsigned_in_user, only: [:new, :create]

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
		@user = User.new(user_params)

		if @user.save then
			sign_in @user
			flash[:success] = "Welcome buddy :)"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit

	end

	def update
	    if @user.update_attributes(user_params)
	      flash[:success] = "Profile has been updated"
	      sign_in @user
	      redirect_to @user
	    else
	      render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
	    flash[:success] = "User destroyed."
	    redirect_to users_url
	end

	private
		def user_params
			params[:user].permit(:name, :email, :password, :password_confirmation)
		end

		def signed_in_user
			if ! signed_in?
				store_location
      			redirect_to signin_url, notice: "Please sign in."
      		end
		end

		def correct_user
	      	@user = User.find(params[:id])
	      	redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end

		def unsigned_in_user
			redirect_to(root_path) if signed_in?
		end

end
