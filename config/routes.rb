Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations' }
  get '/user', to: "dashboard#index", as: :user_root

  root "landing#index"
  # root    "dashboard#index"
  get  "/dashboard",           to: "dashboard#index"
  post "/switch_organization", to: "dashboard#switch_organization"
  post "/switch_channel",      to: "dashboard#switch_channel"
  get  "/feature1",            to: "test#feature1"
  get  "/feature2",            to: "test#feature2"

  resource :invites, as: 'invite', path: 'invitation', only: [] do
    delete :cancel
  end

  resource   :organizations,      as: 'organization', path: "/organization", except: [:index, :show] do
    resource :organization_roles, as: 'role',         path: "/role",         only:   [:update, :destroy] do
      post :new,                as: 'new',          path: '/new'
      get :create,              as: 'accept',       path: '/:token'
    end
  end

  resource    :channels,      as: 'channel',  path: '/channel', except: :index do
    get 'landing/:id',      as: 'landing',    to: 'channels#landing'
    post :deliver
    resource  :channel_roles, as: 'role',     path: '/role',    only: [:update, :destroy] do
      post :new,            as: 'new',        path: '/new'
      get :create,          as: 'accept',     path: '/:token'
    end
  end

  resources   :link_groups, as: 'link_group', path: 'link_group' do
    collection do
      post :update_group_position
    end
  end

  resources   :saved_links, as: 'saved_link', path: 'saved_link' do
    collection do
      post :link_move_in_group
      post :link_change_group
      post :crawler
    end
  end
  
  resources   :articles,    as: 'article',    path: 'article',  except: :index do
    member do
      post :sort
      post :header
      post :footer
      get :read
    end
    resources :contents, only: [:create, :index]
  end

  resources   :contents, only: [:update, :destroy]

  post "/subscribe",                as: "subscribe",   to: "subscribers#create"
  get  "/unsubscribe/:channel_id/", as: "unsubscribe", to: "subscribers#destroy"

  get '/users', to: "landing#index", as: "regist_refresh_error"
end  