Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get '/user', to: "dashboard#index", as: :user_root

  root   "dashboard#index"
  resources :dashboard, only: [:index, :update]

  get     "/feature1",               to: "test#feature1"
  get     "/feature2",               to: "test#feature2"

  resources     :invites, only: [] do
    collection do
      delete :cancel
      post :new, as: "send"
      get :accept
    end
  end

  resources     :organizations,      as: 'organization', path: "/org", except: [:index] do
    resources   :organization_roles, as: 'role',path: "/role",      except: [:index, :edit]

    resources   :channels,           as: 'channel',  path: '/c',     except: [:index] do
      resources :channel_roles,      as: 'role',path: '/role',      except: [:index, :edit]

      resources :link_groups do
        resources :saved_links
      end

      resources :articles do
        resources :contents
      end
    end # channel
  end # organization
end  # Rails draw do