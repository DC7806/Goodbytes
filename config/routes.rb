Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  root    "dashboard#index"

  get     "/feature1",               to: "test#feature1"
  get     "/feature2",               to: "test#feature2"

  post    "/invite/send",            to: "invites#create"
  delete  "/invite/cancel",          to: "invites#destroy"

  get     "/organization/join",      to: "invites#join_to_organization"
  get     "/organization/invited",   to: "invites#sign_up_and_join"
  post    "/organization/promotion", to: "organization_roles#update"
  delete  "/organization/fire",      to: "organization_roles#destroy"

  # get     "/channel/:channel_id",    to: "channels#show",               as: "channel"
  # post    "/channel",                to: "channels#create",             as: "channel_create"
  # post    "/channel/update",         to: "channels#update",             as: "channel_update"
  # delete  "/channel",                to: "channels#destroy",            as: "channel_destroy"

  resources :channels, path: "/channel", 
                       only: [
                         :show, 
                         :create, 
                         :update, 
                         :destroy
                        ]
  
  # devise_scope :users do
  #   post "/users/sign_up" => "users/registrations#invited"
  # end
  
end
