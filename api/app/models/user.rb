# frozen_string_literal: true

class User < ActiveRecord::Base
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :validatable,
          :trackable,
          :omniauthable,
          omniauth_providers: [:twitter]

  include DeviseTokenAuth::Concerns::User
end
