class ApplicationController < ActionController::Base
  def generate_token(len)
    len.times.map{rand(0..35).to_s(36)}.join
  end
end