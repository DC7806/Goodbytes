class DashboardController < ApplicationController
  def index
    give_a_session_when_first_time_come
    if session_has_no_current_channel
      # 符合條件要加個return不然redirect之後這個function會繼續執行下去
      # 造成重複redirec錯誤
      return if new_user_go_create_channel
      set_current_channel_and_org
    end
    redirect_to channel_path
  end

  def switch_org # switch current channel
    # 因為側邊欄的channel選單只能回傳一個值，不得已只好在前端設計好變數的樣子
    # 把organization_id跟channel_id塞在一個字串裡，用｜分開
    session["goodbytes7788"]["organization_id"] = params[:id].to_i
    channel = current_channels.first
    session["goodbytes7788"]["channel_id"] = channel && channel.id || nil
    redirect_to channel_path
  end

  def switch_ch # switch current channel
    # 因為側邊欄的channel選單只能回傳一個值，不得已只好在前端設計好變數的樣子
    # 把organization_id跟channel_id塞在一個字串裡，用｜分開
    session["goodbytes7788"]["channel_id"] = params[:id].to_i
    redirect_to channel_path
  end

  # 方法名稱都寫的粉清楚了，應該....不用再多說明了吧？qq
  private
  def give_a_session_when_first_time_come
    unless session["goodbytes7788"]
      session["goodbytes7788"] = {}
    end
  end
  def session_has_no_current_channel
    return !session["goodbytes7788"]["channel_id"]
  end

  def new_user_go_create_channel
    @channel = current_user.channels.first
    unless @channel
      org_id = current_user.organizations.find_by(name: current_user.email).id
      redirect_to new_channel_path, notice: "新增你的第一個頻道～"
      # 這邊要回傳true or false以供上方的存取介面做判斷
      return true
    end
    return false
  end

  def set_current_channel_and_org
    session["goodbytes7788"]["organization_id"] = @channel.organization_id
    session["goodbytes7788"]["channel_id"]      = @channel.id
  end

end
