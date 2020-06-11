# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :check_session_empty
  
end
