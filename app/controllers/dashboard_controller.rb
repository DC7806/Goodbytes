class DashboardController < ApplicationController
  def index
    unless session["goodbytes7788"]
      session["goodbytes7788"] = {}
    end
    site = session[:goodbytes7788]
    unless site["organization_id"] && site["channel_id"]
      channel = current_user.channels.first
      site["organization_id"] = channel.organization_id
      site["channel_id"] = channel.id
    end
    redirect_to organization_channel_path(
      organization_id: site["organization_id"], 
      id: site["channel_id"]
    )
  end

  def update # switch current channel
    org_id, ch_id = params[:org_ch].split("|")
    session[:goodbytes7788]["organization_id"] = org_id
    session[:goodbytes7788]["channel_id"] = ch_id
    # debugger
    redirect_to organization_channel_path(organization_id: org_id, id: ch_id)

  end

end
