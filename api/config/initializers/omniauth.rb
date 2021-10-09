Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV.fetch("APP_KEY"), ENV.fetch("SECRET_KEY"), callback_url: "http://127.0.0.1:3000/omniauth/twitter/callback"
  provider :google_oauth2, ENV.fetch("GOOGLE_APP_KEY"), ENV.fetch("GOOGLE_SECRET_KEY"), callback_url: "http://127.0.0.1:3000/omniauth/google_oauth2/callback"
end