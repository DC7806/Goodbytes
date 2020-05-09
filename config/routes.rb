Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  post "/users/sign_up", to: "users/registrations#new", as: "invite_user_registration"
  root "main#index"
end
