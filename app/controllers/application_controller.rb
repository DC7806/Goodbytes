class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  def generate_token(len)
    len.times.map{rand(0..35).to_s(36)}.join
  end

  def role_list
    ['admin','member']
  end
end
