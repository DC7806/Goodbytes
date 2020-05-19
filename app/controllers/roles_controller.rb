class RolesController < ApplicationController
  
  def new
    params_require(:email, :model_object)
    if current_user.send_invitation
                   .from(@model_object)
                   .to(@email)
      @notice = "邀請信件已寄出"
    else
      @notice = "此成員已加入！"
    end
    redirect_to root_path, notice: @notice
  end

  def create
    params_require(:invite_token, :model_object)
    invite = Invite.find_by(token: @invite_token)

    if invite && @model_object.update_role(current_user.id, member)
      invite.destroy
      @notice = "歡迎加入"
    else
      @notice = "無效的操作"
    end
    redirect_to root_path, notice: @notice
  end

  def update
    params_require(:user_id, :role, :model_object)
    if @model_object.update_role(@user_id, @role)
      @notice = "權限更新成功"
    else
      @notice = "權限更新失敗"
    end
    redirect_to root_path, notice: @notice
  end

  def destroy
    params_require(:user_id, :model_object)
    relationship = @model_object.relationship(@user_id)
    if relationship.role == admin
      @notice = "不能開除admin"
    else
      relationship.destroy
      @notice = "成功刪除！"
    end
    redirect_to root_path, notice: @notice
  end

end
