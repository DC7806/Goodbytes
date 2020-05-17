class InvitesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:sign_up_and_join]

  def new
    invite_params = params_require(:organization_id, :email)
    if params[:channel_id]
      path = new_organization_channel_role_path(
        **invite_params,
        channel_id: params[:channel_id]
      )
    else
      path = new_organization_role_path(**invite_params)
    end
    redirect_to path
  end

  def accept
    repost_params = {
      options: {
        method: :post,                  
        authenticity_token: 'auto',                  
        autosubmit: true
      }
    }
    path_params = params_require(:organization_id)
    accept_params = params_require(:organization_id, :invite_token)
    if params[:channel_id]
      accept_params[:channel_id] = params[:channel_id]
      path = organization_channel_role_index_path(**path_params, channel_id: @channel_id)
    else
      path = organization_role_index_path(**path_params)
    end
    redirect_post(
      path,
      params: accept_params,
      **repost_params
    )
  end

  def destroy # 刪除邀請
    params_require(:invite_token)
    invite = Invite.find_by(token: @invite_token)
    if invite
      invite.destroy
      message = "刪除成功！"
    else
      message = "操作失敗！"
    end
    redirect_to root_path, notice: message
  end

end
