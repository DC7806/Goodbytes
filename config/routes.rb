Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  root   "dashboard#index"
  post   "/invite/send",            to: "invites#create"

  get     "/feature1",               to: "test#feature1"
  get     "/feature2",               to: "test#feature2"
  delete "/invite/cancel",          to: "invites#destroy"

  get    "/organization/join",      to: "invites#join_to_organization"
  get    "/organization/invited",   to: "invites#sign_up_and_join"

  resources     :organizations,      as: 'org', path: "/",       only: [:create, :update, :destroy] do

    resources   :organization_roles, as: 'role',path: "/role",   only: [:update, :destroy]
    resources   :channels,           as: 'ch',  path: '/',     except: [:index, :new, :edit] do

      resources :channel_roles,      as: 'role',path: '/role', except: [:index, :edit]
    end
  end
  
end
