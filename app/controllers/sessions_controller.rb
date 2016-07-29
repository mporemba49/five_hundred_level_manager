class SessionsController < ApplicationController
  def login
    @user = User.new
  end

  def confirm_login
    @user = User.find_by_email(params[:email])
    if @user && @user.password == params[:password]
      session[:user_id] = @user.id
      redirect_to clothing_index_path
    else
      flash[:error] = "Invalid Email/Password"
      redirect_to login_path
    end
  end

  def logout
    reset_session
    flash[:notice] = "Successfully Logged Out"
    redirect_to login_path
  end

end
