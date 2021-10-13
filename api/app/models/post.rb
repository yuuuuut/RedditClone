class Post < ApplicationRecord
  belongs_to :user

  enum status: { draft: 0, public: 1 }, _prefix: true
end
