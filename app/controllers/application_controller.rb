class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :current_channel, :current_organization

  private
  def params_require(*args, target: nil)
    
    target_classes = [ActionController::Parameters, Hash]

    if target
      unless target_classes.include?(target.class)
        raise TypeError, "Params_require: Your target must be 'params' or hash."
      end
    else
      target = params
    end

    key_types = [String, Symbol]

    args.each do |key|
      unless key_types.include? key.class
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

  def find_organization
    org_id = (params[:organization_id] || params[:id])
    @organization = Organization.find(org_id)
  end

  def find_channel
    ch_id = (params[:channel_id] || params[:id])
    @channel = Channel.find(ch_id)
  end

  def org_admin?
    admin? @organization
  end

  def channel_admin?
    admin? @channel
  end

  def admin?(acceptor)
    user_id = current_user.id
    unless acceptor && acceptor.role(user_id) == 'admin'
      redirect_to root_path, notice: '沒有權限進行此操作！'
      return false
    end
    return true
  end
  
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
