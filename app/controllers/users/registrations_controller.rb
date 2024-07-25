# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: %i[create new]
    before_action :configure_account_update_params, only: %i[update]
    before_action :authenticate_user!, only: [:destroy]

    def destroy
      current_user.destroy
      sign_out
      redirect_to new_user_session_path, status: :see_other, notice: I18n.t('users.account_destroyed')
    end

    private

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
    end
  end
end
