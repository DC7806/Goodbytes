class InvitesController < ApplicationController

  def cancel # 刪除邀請
    invite = Invite.find_by(token: params[:token])
    if invite
      invite.destroy
      @notice = "邀請刪除成功！"
    else
      byebug
      @notice = "操作失敗！"
    end
    redirect_to root_path, notice: @notice
  end

end
