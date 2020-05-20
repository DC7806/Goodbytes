Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get '/user', to: "dashboard#index", as: :user_root

  root   "dashboard#index"
  resource :dashboard, only: [:index, :update]

  get     "/feature1",               to: "test#feature1"
  get     "/feature2",               to: "test#feature2"

  resource :invites, as: 'invite', path: 'invitation', only: [] do
    collection do
      delete :cancel
      post :new, as: "send"
      get :accept
    end
  end

  resource    :organizations,      as: 'organization', path: "/organization", except: [:index, :show] do
    resource  :organization_roles, as: 'role',         path: "/role",         except: [:index, :edit, :show]
  end

  resource    :channels,           as: 'channel',      path: '/channel',      except: [:index] do
    resource  :channel_roles,      as: 'role',         path: '/role',         except: [:index, :edit]
  end

  resources   :link_groups,        as: 'link_group',   path: 'link_group'
  resources   :saved_links,        as: 'saved_link',   path: 'saved_link'

  resources   :articles,           as: 'article',      path: 'article'

end  # Rails draw do