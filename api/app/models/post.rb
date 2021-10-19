class Post < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :user
  has_one :post_image

  enum status: { draft: 0, public: 1 }, _prefix: true
  enum type: { no: 0, user: 1, community: 2 }, _prefix: true

  def create_post_image(url, uid)
    return if url.blank? || uid.blank?
    self.build_post_image(url: url, uid: uid)
  end
end
