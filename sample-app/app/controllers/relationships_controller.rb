class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_relationship, only: :destroy
  before_action :load_user, only: :create
    
  def create
    current_user.follow @user
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
  end
  
  def destroy
    current_user.unfollow @user
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
  end

  private
 
  def load_relationship
    @user = Relationship.find_by(id: params[:id]).followed
    return if @user
    flash[:danger] = t "sessions.flash.undefine_user"
    redirect_to root_url
  end
  
  def load_user
    @user = User.find_by id: params[:followed_id] 
    return if @user
    flash[:danger] = t "sessions.flash.undefine_user"
    redirect_to root_url
  end
end
