# frozen_string_literal: true

module Users
  # Controller related to Omniauth Callback methods for users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy

    def oidc
      openid
    end

    def openid
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
      else
        failure
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
