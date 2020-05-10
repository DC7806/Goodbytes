Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root "main#index"
  post "/invited", to: "invites#new"#, as: "invite_user_registration"
  # devise_scope :users do
  #   post "/users/sign_up" => "users/registrations#invited"
  # end
end
