class DashboardController < ApplicationController
  def index
    #@user = current_user
    #TODO: if not login  redirect to /login
    @user = User.first
    @things = @user.things
  end
end
