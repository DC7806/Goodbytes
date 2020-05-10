Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root "main#index"
  post "/organization/send_invite",to: "invites#create"
  get "/organization/join",        to: "invites#join_to_organization"
  get "/organization/invited",     to: "invites#sign_up_and_join"#, as: "invite_user_registration"
  post "/organization/promotion",  to: "organization_roles#update"
  delete "/organization/fire",     to: "organization_roles#destroy"
  # devise_scope :users do
  #   post "/users/sign_up" => "users/registrations#invited"
  # end
end
