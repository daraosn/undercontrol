# config/initializers/upmin.rb
# Extends the Upmin ApplicationController to limit access to users with an admin role.
# Depends on Devise for authentication plus role-based authorization.
# Be sure to restart your server when you modify this file.
module AdminOnly
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :admin_only
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
    rescue ActionController::RedirectBackError
      redirect_to '/', :alert => "Access denied."
  end

end

Upmin::ApplicationController.send :include, AdminOnly
