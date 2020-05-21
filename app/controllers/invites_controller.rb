class InvitesController < ApplicationController

  def new
    if params[:channel_id]
      path = new_channel_role_path(
        organization_id: params[:organization_id],
        email: params[:email],
        channel_id: params[:channel_id]
      )
    else
      path = new_organization_role_path(
        organization_id: params[:organization_id],
        email: params[:email]
      )
    end
    redirect_to path
  end

  def cancel # 刪除邀請
    invite = Invite.find_by(token: params[:invite_token])
    if invite
      invite.destroy
      @notice = "刪除成功！"
    else
      @notice = "操作失敗！"
    end
    redirect_to root_path, notice: @notice
  end

end
