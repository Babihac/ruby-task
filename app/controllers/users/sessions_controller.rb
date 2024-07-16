# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action :configure_sign_in_params, only: %i[new create]

    private

    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password remember_me])
    end
  end
end
