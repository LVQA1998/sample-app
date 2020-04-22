class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated?
        log_in user
        params[:session][:remember_me] == Settings.remember_me ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = t"sessions.flash.not_activated"
        message += t"sessions.flash.activation_link"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash[:danger] = t "sessions.flash.danger"
      render :new
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
