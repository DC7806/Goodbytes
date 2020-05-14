Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  root    "dashboard#index"

  get     "/feature1",               to: "test#feature1"
  get     "/feature2",               to: "test#feature2"

  post    "/invite/send",            to: "invites#create"
  delete  "/invite/cancel",          to: "invites#destroy"

  # get     "/channel/:channel_id",    to: "channels#show",               as: "channel"
  # post    "/channel",                to: "channels#create",             as: "channel_create"
  # post    "/channel/update",         to: "channels#update",             as: "channel_update"
  # delete  "/channel",                to: "channels#destroy",            as: "channel_destroy"

  resources     :organizations,      as: 'org', path: "/",       only: [:create, :update, :destroy] do

    resources   :organization_roles, as: 'role',path: "/role",   only: [:update, :destroy]
    resources   :channels,           as: 'ch',  path: '/',     except: [:index, :new, :edit] do

      resources :channel_roles,      as: 'role',path: '/role', except: [:index, :edit]
    end
  end
  
  # devise_scope :users do
  #   post "/users/sign_up" => "users/registrations#invited"
  # end
  
end
