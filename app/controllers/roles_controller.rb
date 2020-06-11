class RolesController < ApplicationController
  # around_action :redirect_back_to_edit_page, except: [:create]
  
  def new
    @notice = current_user.send_invitation
                          .from(@model_object)
                          .to(params[:email])
    redirect_back_to_edit_page
  end

  def create
    invite = Invite.find_by(token: params[:token])
    if invite && invite.item.update_role(current_user.id, member)
      invite.destroy
      @notice = "歡迎加入"
    else
      @notice = "無效的操作"
    end
    redirect_to channel_path, notice: @notice
  end

  def update
    if @model_object.update_role(params[:user_id], params[:role])
      @notice = "權限更新成功"
    else
      @notice = "權限更新失敗"
    end
    redirect_back_to_edit_page
  end

  def destroy
    relationship = @model_object.relationship(params[:user_id].to_i)
    if relationship.role == admin
      @notice = "不能開除admin"
    else
      relationship.destroy
      @notice = "成功刪除！"
    end
    redirect_back_to_edit_page
  end

  private
  def redirect_back_to_edit_page
    class_name = @model_object.class.to_s.downcase
    redirect_to "/#{class_name}/edit", notice: @notice
  end

end
