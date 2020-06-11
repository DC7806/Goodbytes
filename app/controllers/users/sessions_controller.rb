# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout "landing"
  skip_before_action :check_session_empty
  # before_action :configure_sign_in_params, only: [:create]

end
