class Post < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :user
  belongs_to :community, optional: true
  has_one :post_image

  enum status: { draft: 0, public: 1 }, _prefix: true
  enum type: { none: 0, user: 1, community: 2 }, _prefix: true

  scope :post_includes, -> { includes(:user, :community, :post_image) }

  def self.sort(sort_type)
    return order(created_at: "DESC") if sort_type == 'new'
    return order(created_at: "ASC") if sort_type == 'top'
    order(created_at: "DESC")
  end

  def create_community_if_exists(community_id)
    community = Community.find_by(name: community_id)
    self.update!(community: community) if community.present?
  end

  def update_post_image(url, uid)
    post_image = PostImage.find_by(post: self)
    if (url.blank? || uid.blank?)
      return if post_image.nil?
      post_image.destroy!
    else
      return self.create_post_image!(url: url, uid: uid) if post_image.nil?
      post_image.update!(url: url, uid: uid)
    end
  end
end
