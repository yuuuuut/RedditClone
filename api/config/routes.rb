Rails.application.routes.draw do
  namespace :api, format: "json" do
    namespace :v1 do
      # Devise
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations',
        omniauth_callbacks: 'api/v1/auth/omniauth_callbacks'
      }

      resources :posts, only: [:index]
    end
  end
end
