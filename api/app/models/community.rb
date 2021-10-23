# frozen_string_literal: true

class Community < ApplicationRecord
  has_many :user_communities
  has_many :users, through: :user_communities, source: :user
  has_many :posts
end