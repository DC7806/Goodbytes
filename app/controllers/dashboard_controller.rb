class DashboardController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :regist_error
  ]
  def index
    give_a_session_when_first_time_come
    if session_has_no_current_channel
      # 符合條件要加個return不然redirect之後這個function會繼續執行下去
      # 造成重複redirect錯誤
      return if new_user_go_create_channel
      set_current_channel_and_org
    end
    redirect_to channel_path
  end

  def switch_organization # switch current organization
    # 設置session內的organization_id，因為從html form傳來的值是字串所以to_i
    session["goodbytes7788"]["organization_id"] = params[:id].to_i
    # current_channelsssssssssss 請參考application controller
    channel = current_channels.first
    if channel
      # 如果channel有找到就設置current channel id
      session["goodbytes7788"]["channel_id"] = channel.id
    else
      # 否則設為nil，後續讓find channel去處理
      session["goodbytes7788"]["channel_id"] = nil
    end
    redirect_to channel_path
  end

  def switch_channel # switch current channel
    # 設置session內的organization_id，因為從html form傳來的值是字串所以to_i
    session["goodbytes7788"]["channel_id"] = params[:id].to_i
    redirect_to channel_path
  end

  def regist_error
    redirect_to new_user_registration_path
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
      org_id = current_user.organizations.find_by(name: current_user.email)&.id
      session["goodbytes7788"]["organization_id"] = org_id
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
