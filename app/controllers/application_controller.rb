class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, 
              with: :redirect_if_not_found
  helper_method :current_organization_id, :current_channel_id, 
                :current_organization,    :current_channel,
                                          :current_channels
  before_action :check_session, only: [:current_channel_id, :current_organization_id]                                        

  private

  def check_session
    unless session["goodbytes7788"]
      redirect_to dashboard_path
    end
  end

  def current_channel_id
    session["goodbytes7788"]["channel_id"]
  end

  def current_channel
    # 從session內抓出當前channel
    Channel.find(current_channel_id)
  end

  def current_channels
    # 從當前organization的channels跟user有權限的channels做交集比對
    # 回傳的是當前organization內user有權限的channels
    current_organization.channels & current_user.channels
  end

  def find_channel
    # 這一行是要留給錯誤訊息印出來的
    @model_name = "channel"
    if @subobject
      # 子物件，如果這個find_channel方法是在子物件層級被呼叫
      # 則子層此時會帶有一個@subobject，channel此時變成從子物件身上找
      @channel = @subobject.channel
    elsif current_channel_id
      # 如果session內有當前channel id的話則用該id來找channel
      @channel = current_channel
    elsif purview_check(current_organization, admin)
      # current_channel_id不存在的情況請參考上面的current_channels與dashboard#switch_org
      # 簡單說就是組織內沒有頻道，或者沒有可以讓你編輯的頻道
      # 此時進一步做組織權限判斷，如果是admin就叫你創頻道
      @channel = current_organization.channels.build
      render "channels/new", notice: "創個新頻道吧！"
    elsif purview_check(current_organization, member)
      # 而如果是organization member代表此組織沒有可以給你編輯的channel
      # TODO: 這邊的render應該之後要有個模版可以給他render，暫時先這樣
      render html: "此組織目前沒有可供編輯的頻道～", layout: true
    else
      redirect_to root_path, notice: '沒有權限進行此操作！'
    end
  end

  def current_organization_id
    session["goodbytes7788"]["organization_id"]
  end

  def current_organization
    Organization.find(current_organization_id)
  end

  def find_organization
    # 這一行是要留給錯誤訊息印出來的
    @model_name = "organization"
    if @channel
      @organization = @channel.organization
    else
      @organization = current_organization
    end
  end

  # 如果找不到channel或organization，就把session裡的兩個current id 設為nil
  # 並轉回root，讓dashboard #index去重新抓使用者的organization跟channel
  def redirect_if_not_found
    clean_session
    @notice = "對不起我們找不到 #{@model_name}." if !@notice
    redirect_to root_path, notice: @notice
  end

  def clean_session
    session["goodbytes7788"]["organization_id"] = nil
    session["goodbytes7788"]["channel_id"]      = nil
  end

  # 權限檢查，傳入的第一個物件是channel物件或是organization物件
  # 後面purview帶個星號代表可傳入不定數量的參數，此時在method內的purview會是一個array
  # 或許會注意到星號就是打散的意思，運用方式：array就是一顆星，hash就是兩顆星
  # 泰安老師有教吼！！！！！賣擱問啊！！！！
  def purview_check(model_object, *purview)
    user_id = current_user.id
    purview.include? (model_object && model_object.role(user_id))
  end

  def redirect_if_not_allow(model_object, *purview)
    unless purview_check(model_object, *purview)
      clean_session
      respond_to do |format|
        format.html { redirect_to root_path, notice: '沒有權限進行此操作！' }
        format.json { head :no }
      end
      
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
    redirect_if_not_allow @organization, admin
  end

  def channel_admin?
    redirect_if_not_allow @channel, admin
  end

  # admin也算member中的一員
  def org_member?
    redirect_if_not_allow @organization, admin, member
  end

  def channel_member?
    redirect_if_not_allow @channel, admin, member
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
