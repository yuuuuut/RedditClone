# frozen_string_literal: true

class User < ActiveRecord::Base
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :validatable,
          :trackable,
          :omniauthable,
          omniauth_providers: [:twitter, :google_oauth2]

  include DeviseTokenAuth::Concerns::User

  has_many :posts, dependent: :destroy

  validates :uname, uniqueness: true

  def self.processing_uname(uname)
    'Own_' + uname
  end

end
