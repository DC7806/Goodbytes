module ApplicationHelper
  def path_params
    ch_id = params[:channel_id]       || params[:id] || session["goodbytes7788"]["channel_id"]
    org_id = params[:organization_id] || params[:id] || session["goodbytes7788"]["organization_id"]
    return {channel_id: ch_id, organization_id: org_id}
  end
end
