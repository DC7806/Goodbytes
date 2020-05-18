class DashboardController < ApplicationController
  def index
    give_a_session_when_first_time_come
    if have_no_current_channel
      if new_regist_user
        return
      else
        set_current_channel_and_org
      end
    else
      redirect_to organization_channel_path(
        organization_id: session[:goodbytes7788]["organization_id"], 
                    id: session[:goodbytes7788]["channel_id"]
      )
    end
  end

  def update # switch current channel
    org_id, ch_id = params[:org_ch].split("|")
    session[:goodbytes7788]["organization_id"] = org_id
    session[:goodbytes7788]["channel_id"]      = ch_id
    redirect_to organization_channel_path(organization_id: org_id, id: ch_id)
  end

  private
  def give_a_session_when_first_time_come
    unless session["goodbytes7788"]
      session["goodbytes7788"] = {}
    end
  end
  def have_no_current_channel
    return !(session[:goodbytes7788]["organization_id"] && session[:goodbytes7788]["channel_id"])
  end

  def new_regist_user
    @channel = current_user.channels.first
    unless @channel
      org_id = current_user.organizations.find_by(name: current_user.email).id
      redirect_to new_organization_channel_path(organization_id: org_id), notice: "新增你的第一個頻道～"
      return true
    end
    return false
  end

  def set_current_channel_and_org
    session[:goodbytes7788]["organization_id"] = @channel.organization_id
    session[:goodbytes7788]["channel_id"] = @channel.id
  end
end
