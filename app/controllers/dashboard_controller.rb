class DashboardController < ApplicationController
  def index
    @measurements ||= Measurement.all
  end
end
