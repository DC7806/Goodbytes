class RolesController < ApplicationController
  # around_action :redirect_back_to_edit_page, except: [:create]
  
  def new
    if current_user.send_invitation
                   .from(@model_object)
                   .to(params[:email])
      @notice = "邀請信件已寄出"
    else
      @notice = "此成員已加入！"
    end
    redirect_back_to_edit_page
  end

  def create
    invite = Invite.find_by(token: params[:token])
    if invite && invite.item.update_role(current_user.id, member)
      path = "/switch_#{invite.item_type.downcase}"
      options = {	
        method: :post,                  	
        authenticity_token: 'auto',                  	
        autosubmit: true	
      }
      redirect_post(	
        path,	
        params: {id: invite.item_id},	
        options: options
      )
      invite.destroy
    else
      redirect_to channel_path, notice: "無效的操作"
    end
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
