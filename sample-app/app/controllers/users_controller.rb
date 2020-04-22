class UsersController < ApplicationController
  def new 
    @user = User.new
  end

  def show 
    @user = User.find_by id: params[:id]
    return if @user.present? 
    
    flash[:danger] = t "undefine_user"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "greeting" 
      redirect_to @user
    else
      flash[:danger] = t "signup_fail"
      render :new
    end
  end

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end
end
