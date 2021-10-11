class Api::V1::Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def redirect_callbacks
    super
  end

  def omniauth_success
    super
    update_auth_header
  end

  def omniauth_failure
    super
  end

  protected

  def get_resource_from_auth_hash
    super
  end

  def render_data_or_redirect(message, data, user_data = {})
    # ヘッダーにTokenなどの情報を付与
    update_auth_header
    access_token = response.headers['access-token']
    client = response.headers['client']
    uid = response.headers['uid']
  
    redirect_to "http://localhost:8080/auth/callback?access_token=#{access_token}&client=#{client}&uid=#{uid}"
  end
end