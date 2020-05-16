Rails.application.routes.draw do
  get 'channel/create'
  get 'channel/update'
  get 'channel/destroy'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  root   "dashboard#index"
  get    "/feature1",               to: "test#feature1"
  post   "/invite/send",            to: "invites#create"
  delete "/invite/cancel",          to: "invites#destroy"
  get    "/organization/join",      to: "invites#join_to_organization"
  get    "/organization/invited",   to: "invites#sign_up_and_join"
  post   "/organization/promotion", to: "organization_roles#update"
  delete "/organization/fire",      to: "organization_roles#destroy"
  # get    "/channel/:channel_id",    to: "channels#show"

  resources :channels, only: [:show, :create, :update, :destroy] do
    resources :link_groups do
      resources :saved_links
    end
  end 



  # devise_scope :users do
  #   post "/users/sign_up" => "users/registrations#invited"
  # end
  
end
