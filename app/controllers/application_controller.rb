class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, 
              with: :redirect_if_not_found
  helper_method :get_organization_id, :get_channel_id, 
                                      :current_organization, 
                                      :current_channel

  private
  def params_checker(*args, target: nil)
    
    # 檢查傳進來的target物件種類是否為以下: 1.我們常在用的那個params 2.就hash
    # 如果不是，就噴錯誤
    target_classes = [ActionController::Parameters, Hash]

    if target
      unless target_classes.include?(target.class)
        raise TypeError, "params_checker: Your target must be 'params' or hash."
      end
    else
      # 如果使用此方法時沒有傳target物件進來則預設會去抓params
      target = params
    end

    # 限定使用的key種類只能是symbol或是string
    key_types = [String, Symbol]
    # 給一個空的hash收集結果最後回傳
    dict = {}

    args.each do |key|
      # key種類檢查，用上面的array
      unless key_types.include? key.class
        raise TypeError, "params_checker: Your input '#{key}' must be Symbol or String."
      end

      # 如果目標target內有包含傳入的key則建立同名實體變數
      # 若無則進一步檢查是否已現有同名實體變數
      # 都沒有就噴錯
      if target.include?(key)
        dict[key] = target[key]
        # instance_variable_set 是Ruby內建語法
        # 用法是傳入兩個值，第一個是實體變數名，必須是"@"開頭的字串
        # 第二個值是此變數要給予的值，可以是任意種類
        # 比如當我下指令： instance_variable_set( "@hello", "world" )
        # 此時我再找 @hello 這個變數，就會得到 "world"
        instance_variable_set('@' + key.to_s, target[key])
        # instance_variable_get也是差不多道理，傳入實體變數名稱的字串，得到該值
      elsif instance_variable_get('@' + key.to_s )
        next
      else
        raise NameError, "params_checker: Undefined variable '#{key}'."
      end
    end

    return dict
  end

  def current_channel_id
    session["goodbytes7788"]["channel_id"]
  end

  def current_channel
    Channel.find(current_channel_id)
  end

  def find_channel
    @model_name = "channel"
    if @subobject
      @channel = @subobject.channel
    else
      @channel = current_channel
    end
  end

  def current_organization_id
    session["goodbytes7788"]["organization_id"]
  end

  def current_organization
    Organization.find(current_organization_id)
  end

  def find_organization
    @model_name = "organization"
    if @subobject
      @organization = @subobject.organization
    else
      @organization = current_organization
    end
  end

  # 如果找不到channel或organization，就把session裡的兩個current id 設為nil
  # 並轉回root，讓dashboard #index去重新抓使用者的organization跟channel
  def redirect_if_not_found
    session["goodbytes7788"]["organization_id"] = nil
    session["goodbytes7788"]["channel_id"]      = nil
    @notice = "Sorry we cannot find this #{@model_name}." if !@notice
    redirect_to root_path, notice: @notice
    return false
  end

  # 權限檢查，傳入的第一個物件是channel物件或是organization物件
  # 後面purview帶個星號代表可傳入不定數量的參數，此時在method內的purview會是一個array
  # 或許會注意到星號就是打散的意思，運用方式：array就是一顆星，hash就是兩顆星
  # 泰安老師有教吼！！！！！賣擱問啊！！！！
  def purview_check(model_object, *purview)
    user_id = current_user.id
    unless purview.include? (model_object && model_object.role(user_id))
      redirect_to root_path, notice: '沒有權限進行此操作！'
      return false
    end
    return true
  end

  # 為什麼admin跟member不用引號當字串包起來？
  # 因為我在config/initializer底下的customize.rb （我自己加的檔案）
  # 裡面有定義好這兩種方法
  # 以後有對名稱不滿意的只要改那邊，全站就會跟著改
  # 當然已經寫進資料庫的不會跟著改，那就要手動改了，或者寫腳本
  def org_admin?
    purview_check @organization, admin
  end

  def channel_admin?
    purview_check @channel, admin
  end

  # admin也算member中的一員
  def org_member?
    purview_check @organization, admin, member
  end

  def channel_member?
    purview_check @channel, admin, member
  end

  # 待釋疑：
  # unless !nil
  #   p 'one'
  # elsif !nil
  #   p 'two'
  # else
  #   p 'three'
  # end
  # 預期應該是"two"，但是卻出錯，why？

  # 以下是用了無效的helper method，已經跟KT研究過，說是因為版本問題，疑問待釐清

  def current_channel=(x)
    session["goodbytes7788"]["channel_id"] = x.to_i
  end

  def current_organization=(x)
    session["goodbytes7788"]["organization_id"] = x.to_i
  end

end
