class FollowersController < ApplicationController
  before_action :load_user, :logged_in_user

  def index
    @title = t "followers.title"
    @users = @user.followers.page(params[:page]).per Settings.follow.following_per_page
    render "users/show_follow"
  end
end
