class Post < ApplicationRecord
  belongs_to :user
  has_one :post_image

  enum status: { draft: 0, public: 1 }, _prefix: true

  def create_post_image(url, uid)
    return if url.blank? || uid.blank?
    self.build_post_image(url: url, uid: uid)
  end
end
