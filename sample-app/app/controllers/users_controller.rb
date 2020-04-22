class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :admin_user, only: :destroy
  before_action :find_user_by_id, only: %i(edit update show)

  def index
    @users = User.page(params[:page]).per(5)
  end

  def new
    @user = User.new
  end

  def show
    return if @user.present? 
    flash[:danger] = t "sessions.flash.undefine_user"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "greeting" 
      redirect_to @user
    else
      flash[:danger] = t "sessions.flash.signup_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "sessions.flash.update_success"
      redirect_to @user
    else
      flash.now[:danger] = t "sessions.flash.edit_fail"
      render :edit
    end
  end

  def destroy
    destroy_user.destroy
    flash[:success] = t"users.index.user_delete"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def logged_in_user
    return if logged_in?
      store_location
      flash[:danger] = t"sessions.flash.login_?"
      redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end
  
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user_by_id 
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t"sessions.flash.undefine_user"
    redirect_to root_url
  end

  def destroy_user
    User.find_by(id: params[:id])
  end
end
