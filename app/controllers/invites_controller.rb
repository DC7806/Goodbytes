class InvitesController < ApplicationController

  def create
    # 發送邀請時使用此方法，會創一個預先準備好的user記錄以便後續追蹤confirm狀況
    # 不用怕重複，在registration controller我有改寫
    name = params[:name] # 寄件者顯示名稱
    organization_id = params[:organization_id]
    email = params[:email]
    invite_token = generate_token(10)
    user = User.new(
      email: email, 
      password: invite_token # 密碼必填，這邊隨便塞一個，到時受邀者來註冊直接蓋過去即可
    )
    user.save
    relationship = OrganizationsUser.new(
      organization_id: organization_id,
      user_id: user.id,
      role: invite_token
    )
    relationship.save
    InviteMailerJob.perform_now(name, organization_id, email, invite_token)
    redirect_to root_path, notice: "邀請信件已寄出"
  end

  def new
    @invite_org_id = 11321321 #params[:invite_org_id]
    @email = "koten0926@090909" #params[:email]
    @invite_token = "seowjfghndsgvklsdfj" #params[:invite_token]
    render "devise/registrations/new", locals: {
      resource: User.new,
      resource_name: :user
    }
  end

end
