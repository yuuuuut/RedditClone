Rails.application.routes.draw do
  namespace :api, format: "json" do
    namespace :v1 do
      # Devise
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        #registrations: 'api/v1/auth/registrations',
        omniauth_callbacks: 'api/v1/auth/omniauth_callbacks'
      }

      namespace :account do
        get '/me', action: :me
        resources :users do
          collection do
            patch '/update_uname', action: :update_uname
          end
        end
        resources :posts
        resources :communities
      end

      resources :posts
      resources :post_images
      resources :communities
    end
  end
end
