class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  #logger.fatal self.class.to_s + "." + self.action_name
  
  def generate_token(len)
    len.times.map{rand(0..35).to_s(36)}.join
  end

  def params_require(*args, target: nil)
    unless target
      target = params
    end
    args.each do |key|
      unless [String, Symbol].include? key.class
        raise TypeError, "Params_require: Your input '#{key}' must be Symbol or String."
      end
      unless target.include? key
        raise NameError, "Undefined variable '#{key}' in target. "
      end
    end
    args.each do |key|
      if key.class == Symbol
        key = key.to_s
      end
      value = target[key]
      instance_variable_set('@' + key, target[key])
    end
  end

  def org_admin?
    relationship = OrganizationsUser.find_by(
      organization_id: params[:organization_id],
      user_id:         current_user.id
    )
    unless relationship && relationship.role=='admin'
      redirect_to root_path, notice: '沒有權限進行此操作！'
    end
  end


end
