class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :admin_user, only: :destroy
  before_action :load_user, only: %i(edit show update)

  def index
    @users = User.page(params[:page]).per(Settings.record_per_page)
  end

  def new
    @user = User.new
  end

  def edit; end

  def show; end

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
    if @user.destroy
      flash[:success] = t "users.index.user_delete"
    else
      flash[:danger] = t "sessions.flash.destroy_fail"
    end
    redirect_to users_url
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

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "sessions.flash.login"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end
  
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "sessions.flash.undefine_user"
    redirect_to root_url
  end
end
