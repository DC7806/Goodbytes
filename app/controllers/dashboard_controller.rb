class DashboardController < ApplicationController
  def index
    @channels = current_user.channels
  end
end
