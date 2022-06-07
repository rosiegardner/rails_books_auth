class UsersController < ApplicationController

  # before_action :admin_user,     only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "You've successfully signed up!"
      session[:user_id] = @user.id
      redirect_to "/"
    else
      flash[:alert] = "There was a problem signing up."
      redirect_to '/signup'
    end
  end

  # def admin_user
  #   redirect_to(root_url) unless current_user && current_user.admin?
  # end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end