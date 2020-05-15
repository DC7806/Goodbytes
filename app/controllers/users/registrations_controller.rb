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

    super
    params_require(:invite_token,)
    user = resource
    if token.present?
      invite = Invite.find_by(token: @invite_token)
      if invite
        @org = Organization.find(invite.item_id) 
        invite.destroy
      end
    end

    self_org = Organization.new(name: user.email)
    self_org.save

    orgs  = []
    orgs << [self_org, "admin" ]
    orgs << [    @org, "member"] if @org

    orgs.each do |org, role|
      relationship = OrganizationsUser.new(
        organization_id: org.id,
        user_id:         user.id, 
        role:            role
      )
      relationship.save
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
