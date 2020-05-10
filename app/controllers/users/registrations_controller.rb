# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    # 必要參數: email password
    # 非必要參數: organization_id invite_token
    
    organization_id = params[:organization_id].to_i
    invite_token  = params[:invite_token]
    user          = User.find_by(email: params[:user][:email])

    if user 
      invited_record = user.organizations_users.first
      # 再次檢查使用者的token是否跟當初縙出的一樣
      if (
        (not role_list.include?(invite_token)) && 
        invited_record.role            == invite_token && 
        invited_record.organization_id == organization_id
      )
        user.update(password: params[:user][:password])
      else
        redirect_to root_path, notice: "無效的操作"
        return
      end
    else
      super
      user = resource
    end

    if user
      email    = user.email
      self_org = Organization.find_by(name: email)

      if not self_org
        self_org = Organization.new(name: email)
        self_org.save
      end

      orgs  = []
      orgs << [self_org,"admin"]
      orgs << [Organization.find(organization_id.to_i), "member"] if organization_id.present?

      orgs.each do |org, role|
        relationship_params = {
          user_id:         user.id, 
          organization_id: org.id
        }
        relationship      = OrganizationsUser.find_by(relationship_params)
        relationship    ||= OrganizationsUser.new(relationship_params)
        relationship.role = role
        relationship.save
      end
      redirect_to root_path, notice: "歡迎加入歐！！"
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  def destroy
    Organization.destroy_by(name: resource.email)
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :name])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  
end
