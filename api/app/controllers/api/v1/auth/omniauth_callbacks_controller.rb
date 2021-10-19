class Api::V1::Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def redirect_callbacks
    super
  end

  def omniauth_success
    super
  end

  def omniauth_failure
    super
  end

  protected
  def get_resource_from_auth_hash
    # find or create user by provider and provider uid
    if provider_email.present?
      @resource = resource_class.where(
        email: provider_email,
      ).first_or_initialize
    else
      @resource = resource_class.where(
        uid: provider_uid,
      ).first_or_initialize
    end

    @resource = resource_class.where(
      provider: auth_hash['provider']
    ).first_or_initialize

    if @resource.new_record?
      handle_new_resource
    end

    # sync user info with provider, update/generate auth token
    assign_provider_attrs(@resource, auth_hash)

    # assign any additional (whitelisted) attributes
    if assign_whitelisted_params?
      extra_params = whitelisted_params
      @resource.assign_attributes(extra_params) if extra_params
    end

    @resource
  end

  # Provider毎にemailを設定する
  def provider_email
    case auth_hash['provider']
    when 'google_oauth2'
      auth_hash['info']['email']
    when 'twitter'
      auth_hash['info']['email']
    else
      auth_hash['info']['email']
    end
  end

  # Provider毎にuidを設定する
  def provider_uid
    case auth_hash['provider']
    when 'google_oauth2'
      auth_hash['info']['email']
    when 'twitter'
      auth_hash['info']['nickname']
    else
      auth_hash['info']['email']
    end
  end

  def render_data_or_redirect(message, data, user_data = {})
    update_auth_header

    access_token = response.headers['access-token']
    client = response.headers['client']
    uid = response.headers['uid']
  
    redirect_to "http://localhost:8080/auth/callback?access_token=#{access_token}&client=#{client}&uid=#{uid}"
  end

  def assign_provider_attrs(user, auth_hash)
    puts user.inspect()
    case auth_hash['provider']
    when 'google_oauth2'
      user.assign_attributes({
        name: user.name.blank? ? auth_hash['info']['name'] : user.name,
        email: user.email.blank? ? auth_hash['info']['email'] : user.email,
        uid: user.uid.blank? ? auth_hash['info']['email'] : user.uid,
        image: user.image.blank? ? auth_hash['info']['image'] : user.image
      })
    when 'twitter'
      user.assign_attributes({
        nickname: user.nickname.blank? ? auth_hash['info']['nickname'] : user.nickname,
        name: user.name.blank? ? auth_hash['info']['name'] : user.name,
        email: user.email.blank? ? auth_hash['info']['email'] : 'dummy@dummy.com',
        uid: user.uid.blank? ? auth_hash['info']['nickname'] : user.nickname,
        image: user.image.blank? ? auth_hash['info']['image'] : user.image
      })
    else
      super
    end
  end
end