class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :current_channel, :current_organization

  def params_require(*args, target: nil)
    
    target_classes = [ActionController::Parameters, Hash]

    if target
      unless target_classes.include?(target.class)
        raise TypeError, "Params_require: Your target must be 'params' or hash."
      end
    else
      target = params
    end

    args.each do |key|
      unless [String, Symbol].include? key.class
        raise TypeError, "Params_require: Your input '#{key}' must be Symbol or String."
      end
      unless target.include? key
        raise NameError, "Params_require: Undefined variable '#{key}' in target. "
      end
    end

    dic = {}
    
    args.each do |key|
      value = target[key]
      dic[key] = value
      if key.class == Symbol
        key = key.to_s
      end
      instance_variable_set('@' + key, target[key])
    end

    return dic

  end

  def org_admin?(org_id = nil)
    relationship = OrganizationsUser.find_by(
      organization_id: (org_id || params[:organization_id]),
      user_id:         current_user.id
    )
    unless relationship && relationship.role=='admin'
      redirect_to root_path, notice: '沒有權限進行此操作！'
      return false
    end
    return true
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
