class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  #logger.fatal self.class.to_s + "." + self.action_name
  def generate_token(len)
    len.times.map{rand(0..35).to_s(36)}.join
  end
  def admin?
    type = self.class
               .to_s
               .split(/(?=[A-Z])/)
               .first[0..-2]
    role = get_model(type).find(params[type.downcase + '_id'])
                           .role(current_user.id)
    unless role == 'admin'
      redirect_to root_path, notice: '沒有權限進行此操作！'
    end

  end
end
