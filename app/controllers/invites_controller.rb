class InvitesController < ApplicationController

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
