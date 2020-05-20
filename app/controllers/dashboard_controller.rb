class DashboardController < ApplicationController
  def index
    give_a_session_when_first_time_come
    if session_has_no_current_channel
      # 符合條件要加個return不然redirect之後這個function會繼續執行下去
      # 造成重複redirec錯誤
      return if go_to_create_first_channel_if_new_regist_user
      set_current_channel_and_org
    end
    redirect_to_your_channel
  end

  def update # switch current channel
    # 因為側邊欄的channel選單只能回傳一個值，不得已只好在前端設計好變數的樣子
    # 把organization_id跟channel_id塞在一個字串裡，用｜分開
                                 org_id, ch_id = params[:org_ch].split("|")
    session["goodbytes7788"]["organization_id"] = org_id
    session["goodbytes7788"]["channel_id"]      = ch_id
    redirect_to organization_channel_path(organization_id: org_id, id: ch_id)
  end

  # 方法名稱都寫的粉清楚了，應該....不用再多說明了吧？qq
  private
  def give_a_session_when_first_time_come
    unless session["goodbytes7788"]
      session["goodbytes7788"] = {}
    end
  end
  def session_has_no_current_channel
    return !(
      session["goodbytes7788"]["organization_id"] && 
      session["goodbytes7788"]["channel_id"]
    )
  end

  def go_to_create_first_channel_if_new_regist_user
    @channel = current_user.channels.first
    unless @channel
      org_id = current_user.organizations.find_by(name: current_user.email).id
      redirect_to new_organization_channel_path(organization_id: org_id), notice: "新增你的第一個頻道～"
      # 這邊要回傳true or false以供上方的存取介面做判斷
      return true
    end
    return false
  end

  def set_current_channel_and_org
    session["goodbytes7788"]["organization_id"] = @channel.organization_id
    session["goodbytes7788"]["channel_id"]      = @channel.id
  end

  def redirect_to_your_channel
    redirect_to organization_channel_path(
        organization_id: session["goodbytes7788"]["organization_id"], 
                     id: session["goodbytes7788"]["channel_id"]
      )
  end
end
