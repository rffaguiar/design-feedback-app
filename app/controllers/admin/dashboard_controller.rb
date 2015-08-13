class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!

  layout 'admin'

  def index
    @users = User.all
    @spots = Spot.all
    @comments = Comment.all

    # @user = User.joins(:designs).where(:)
    # get the user with the most spots created
    # get the user with the most comments created
  end
end
