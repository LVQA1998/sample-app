class FollowingsController < ApplicationController
  before_action :load_user, :logged_in_user

  def index
    @title = t "following.title"
    @users = @user.following.page(params[:page]).per Settings.follow.following_per_page
    render "users/show_follow"
  end
end
