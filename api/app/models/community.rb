# frozen_string_literal: true

class Community < ApplicationRecord
  self.primary_key = 'name'
  self.inheritance_column = :_type_disabled

  enum type: { public: 0, restricted: 1, private: 2 }, _prefix: true

  has_many :user_communities
  has_many :users, through: :user_communities, source: :user
  has_many :community_moderators
  has_many :moderators, through: :community_moderators, source: :moderator
  has_many :posts

  before_create :initial_setting

  def initial_setting
    self.path = 'r/' + name
    self.main_image = 'https://firebasestorage.googleapis.com/v0/b/redditclone-16a84.appspot.com/o/images%2Fcommunity%2Fmain%2Fgame.png?alt=media&token=761c5fa0-3cb4-4b75-a5b0-5d215a3adada'
    self.header_image = 'https://firebasestorage.googleapis.com/v0/b/redditclone-16a84.appspot.com/o/images%2Fcommunity%2Fmain%2Fgame.png?alt=media&token=761c5fa0-3cb4-4b75-a5b0-5d215a3adada'
  end

  def become_moderator(user)
    moderators << user
  end
end
