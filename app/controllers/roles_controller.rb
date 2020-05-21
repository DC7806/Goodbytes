class RolesController < ApplicationController
  
  def new
    if current_user.send_invitation
                   .from(@model_object)
                   .to(params[:email])
      @notice = "邀請信件已寄出"
    else
      @notice = "此成員已加入！"
    end
    redirect_to root_path, notice: @notice
  end

  def create
    invite = Invite.find_by(token: params[:invite_token])
    if invite && invite.item.update_role(current_user.id, member)
      invite.destroy
      @notice = "歡迎加入"
    else
      @notice = "無效的操作"
    end
    redirect_to root_path, notice: @notice
  end

  def update
    if @model_object.update_role(params[:user_id], params[:role])
      @notice = "權限更新成功"
    else
      @notice = "權限更新失敗"
    end
    redirect_to root_path, notice: @notice
  end

  def destroy
    relationship = @model_object.relationship(params[:user_id])
    if relationship.role == admin
      @notice = "不能開除admin"
    else
      relationship.destroy
      @notice = "成功刪除！"
    end
    redirect_to root_path, notice: @notice
  end

end
