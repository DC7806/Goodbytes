class RolesController < ApplicationController
  
  def new
    params_require(:email)
    params_check(:command, :acceptor_id)
    if current_user.send_invitation
                   .send(@command, @acceptor_id)
                   .to(@email)
      @notice = "邀請信件已寄出"
    else
      @notice = "此成員已加入！"
    end
    redirect_to root_path, notice: @notice
  end

  def create
    params_require(:invite_token)
    params_check(:acceptor)
    invite = Invite.find_by(token: @invite_token)

    if invite && @acceptor.update_role(current_user.id, member)
      invite.destroy
      @notice = "歡迎加入"
    else
      @notice = "無效的操作"
    end
    redirect_to root_path, notice: @notice
  end

  def update
    params_require(:user_id, :role)
    params_check(:acceptor)
    if @acceptor.update_role(@user_id, @role)
      @notice = "權限更新成功"
    else
      @notice = "權限更新失敗"
    end
    redirect_to root_path, notice: @notice
  end

  def destroy
    params_require(:user_id)
    params_check(:acceptor)
    relationship = @acceptor.relationship(@user_id)
    if relationship.role == admin
      @notice = "不能開除admin"
    else
      relationship.destroy
      @notice = "成功刪除！"
    end
    redirect_to root_path, notice: @notice
  end

  private
  def params_check(*needed_params)
    unless needed_params.map{ |sym| instance_variable_get('@' + sym.to_s ) }.all?
      raise NameError, "Parameter needed: #{needed_params.join(",")}"
    end
  end

end
