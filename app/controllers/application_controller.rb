class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :current_channel, :current_organization
  
  def generate_token(len)
    len.times.map{rand(0..35).to_s(36)}.join
  end

  def role_list
    ['admin','member']
  end

  private

  def current_channel
    res = session[:goodbytes7788]["channel_id"]
    return res.to_i if res.present?

  end

  def current_organization
    res = session[:goodbytes7788]["organization_id"]
    return res.to_i if res.present?
  end

  def current_channel=(x)
    session[:goodbytes7788]["channel_id"] = x.to_i
  end

  def current_organization=(x)
    session[:goodbytes7788]["organization_id"] = x.to_i
  end

end
