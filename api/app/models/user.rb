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
  has_many :user_communities
  has_many :communities, through: :user_communities, source: :community

  validates :uname, uniqueness: true

  def self.processing_uname(uname)
    'Own_' + uname
  end

  def join_community(community)
    communities << community
  end

  def disjoin_community(community)
    communities.destroy!(community)
  end

  def joined_community?(community)
    communities.include?(community)
  end

end
