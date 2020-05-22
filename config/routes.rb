Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get '/user', to: "dashboard#index", as: :user_root

  root    "dashboard#index"
  post   "/switch_organization",  to: "dashboard#switch_organization"
  post   "/switch_channel",       to: "dashboard#switch_channel"
  get     "/feature1",            to: "test#feature1"
  get     "/feature2",            to: "test#feature2"

  resource :invites, as: 'invite', path: 'invitation', only: [] do
    collection do
      delete :cancel
    end
  end

  resource    :organizations,      as: 'organization', path: "/organization", except: [:index, :show] do
    resource  :organization_roles, as: 'role',         path: "/role",         only:   [:update, :destroy] do
      collection do
        post :new,                 as: 'new',          path: '/new'
        get :create,               as: 'accept',       path: '/:token'
      end
    end

  end

  resource    :channels,           as: 'channel',      path: '/channel',      except: [:index] do
    resource  :channel_roles,      as: 'role',         path: '/role',         only:   [:update, :destroy]   do
      collection do
        post :new,                 as: 'new',          path: '/new'
        get :create,               as: 'accept',       path: '/:token'
      end
    end
  end

  resources   :link_groups,        as: 'link_group',   path: 'link_group'
  resources   :saved_links,        as: 'saved_link',   path: 'saved_link'
  resources   :articles,           as: 'article',      path: 'article'

      resources :articles do
        resources :contents
      end
    end # channel
  # end # organization
# end  # Rails draw do